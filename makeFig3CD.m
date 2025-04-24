%
clear all
simseed = setrandoms(24060301);

%
ndim = 7;
nsim = 100;
for modeltype = 1:5
    if modeltype == 4
        data.Vs_set = NaN(nsim,8);
        data.ds_set = NaN(nsim,8);
        data.sxupbcos_set = NaN(nsim,10000);
        data.d_trials_set = NaN(1000,10,nsim);
        data.dd_set = NaN(nsim,998,6);
    end
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype,ksim);
        if modeltype ~= 4
            [os,xs,Vs,ds] = rnrl1(modeltype,0.1,0.8,ndim,1000,0);
        else
            [os,xs,Vs,ds,sxupbcos,d_trials] = rnrl1ang(modeltype,0.1,0.8,ndim,1000,0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            data.ds_set(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
            data.sxupbcos_set(ksim,1:length(sxupbcos)) = sxupbcos';
            data.d_trials_set(:,:,ksim) = d_trials;
            for k = 2:1000-1
                data.dd_set(ksim,k-1,:) = d_trials(k,1:6) .* d_trials(k+1,1:6);
            end
        end
    end
end
save(['data_' num2str(simseed) '_ang'],'data');

%
F = figure;
A = axes;
hold on;
tmp_index = find(~isnan(mean(data.sxupbcos_set)),1,'last');
axis([0 tmp_index -10 40]);
P = plot([0 tmp_index],[0 0],'k:');
P = plot([1:tmp_index],mean(acos(data.sxupbcos_set(:,1:tmp_index))*(180/pi),1),'r');
P = plot([1:tmp_index],mean(acos(data.sxupbcos_set(:,1:tmp_index))*(180/pi),1)+...
    std(acos(data.sxupbcos_set(:,1:tmp_index))*(180/pi),0,1),'b');
P = plot([1:tmp_index],mean(acos(data.sxupbcos_set(:,1:tmp_index))*(180/pi),1)-...
    std(acos(data.sxupbcos_set(:,1:tmp_index))*(180/pi),0,1),'b');
set(A,'XTick',[0:2000:8000],'XTickLabel',[0:2000:8000],'YTick',[-10:10:40],'YTickLabel',[-10:10:40],'FontSize',40);
print(F,'-depsc','Fig3C');
%
for k = 1:6
    F = figure;
    A = axes;
    hold on;
    if (k==1) || (k==4)
        axis([0 1000 -0.2 1.2]);
    else
        axis([0 1000 -0.05 0.12]);
    end
    P = plot([0 1000],[0 0],'k:');
    P = plot([2:999],mean(data.dd_set(:,:,k),1),'r');
    P = plot([2:999],mean(data.dd_set(:,:,k),1)+std(data.dd_set(:,:,k),0,1),'b');
    P = plot([2:999],mean(data.dd_set(:,:,k),1)-std(data.dd_set(:,:,k),0,1),'b');
    if (k==1) || (k==4)
        set(A,'XTick',[0:200:1000],'XTickLabel',[0:200:1000],'YTick',[-0.2:0.2:1.2],'YTickLabel',[],'FontSize',40);
    else
        set(A,'XTick',[0:200:1000],'XTickLabel',[0:200:1000],'YTick',[-0.05:0.05:0.1],'YTickLabel',[],'FontSize',40);
    end
    print(F,'-depsc',['Fig3D' num2str(k)]);
end
