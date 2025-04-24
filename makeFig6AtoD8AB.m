%
clear all
simseed = setrandoms(24071201);

%
ndim = 12;
nsim = 100;
P_set = NaN(ndim,ndim+2,nsim);
for modeltype = 3:5
    data.Vs_set{modeltype} = NaN(nsim,8);
    data.ds_set{modeltype} = NaN(nsim,8);
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype,ksim);
        [os,xs,Vs,ds,wbcos,P] = rnrl101cos(modeltype,0.1,0.8,ndim,1500,[],0);
        if modeltype == 4
            P_set(:,:,ksim) = P;
        end
        tmp_last_cue = find(os(1,:),1,'last');
        data.Vs_set{modeltype}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
        data.ds_set{modeltype}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
        tmp_cue = find(os(1,:));
        data.wbangle_set{modeltype}(ksim,:) = acos(wbcos(tmp_cue))*(180/pi);
    end
end
for modeltype = 5
    data.Vs_set{modeltype+1} = NaN(nsim,8);
    data.ds_set{modeltype+1} = NaN(nsim,8);
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype+1,ksim);
        tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+2),1);
        tmp_P = tmp_P(randperm(ndim*(ndim+2)));
        P = reshape(tmp_P,ndim,ndim+2);
        [os,xs,Vs,ds,wbcos,P] = rnrl101cos(modeltype,0.1,0.8,ndim,1500,P,0);
        tmp_last_cue = find(os(1,:),1,'last');
        data.Vs_set{modeltype+1}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
        data.ds_set{modeltype+1}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
        tmp_cue = find(os(1,:));
        data.wbangle_set{modeltype+1}(ksim,:) = acos(wbcos(tmp_cue))*(180/pi);
    end
end
save(['data_add' num2str(simseed)],'data');

%
tmp_ABCD = 'ABCD';
for modeltype = 3:6
    F = figure;
    A = axes;
    hold on;
    axis([-2 5 -0.5 1.5]);
    P = plot([-2 5],[0 0],'k:');
    P = errorbar([-2:5],mean(data.Vs_set{modeltype},1),std(data.Vs_set{modeltype},0,1)/sqrt(nsim),'k--');
    P = plot([-2:5],mean(data.Vs_set{modeltype},1),'k');
    P = errorbar([-2:5],mean(data.ds_set{modeltype},1),std(data.ds_set{modeltype},0,1)/sqrt(nsim),'r--');
    P = plot([-2:5],mean(data.ds_set{modeltype},1),'r');
    set(A,'XTick',[-2:5],'XTickLabel',[-2:5],'YTick',[-0.5:0.5:1.5],'YTickLabel',[-0.5:0.5:1.5],'FontSize',40);
    print(F,'-depsc',['Fig6' tmp_ABCD(modeltype-2) '-L']);
end

%
simseed = 24071201;
load(['data_add' num2str(simseed)]);
load vd_rnrl1_24070601
true_value = mean(vd.vset(:,5));
for modeltype = 3:6
    F = figure;
    A = axes;
    hold on;
    axis([-0.4 1.8 0 35]);
    H = hist(data.Vs_set{modeltype}(:,5),[-0.3:0.1:1.7]);
    P = bar([-0.3:0.1:1.7],H);
    shading flat
    set(P,'FaceColor',0.5*[1 1 1]);
    P = plot([true_value true_value],[0 35],'k:');
    set(A,'XTick',[0:0.5:1.5],'XTickLabel',[0:0.5:1.5],'YTick',[0:5:35],'YTickLabel',[0:5:35],'FontSize',40);
    set(A,'PlotBoxAspectRatio',[3 1 1]);
    print(F,'-depsc',['Fig6' tmp_ABCD(modeltype-2) '-R']);
end

%
modeltype = 4;
F = figure;
A = axes;
hold on;
axis([0 1500 -10 190]);
P = plot([0 1500],[0 0],'k:');
P = plot([0 1500],[180 180],'k:');
P = plot([0 1500],[90 90],'k');
P = plot([0 1500],[45 45],'k-.');
P = plot([1:1500],mean(data.wbangle_set{modeltype},1)+std(data.wbangle_set{modeltype},0,1),'r--'); % SD (rather than SEM)
P = plot([1:1500],mean(data.wbangle_set{modeltype},1)-std(data.wbangle_set{modeltype},0,1),'r--'); % SD (rather than SEM)
P = plot([1:1500],mean(data.wbangle_set{modeltype},1),'r');
set(A,'XTick',[0:500:1500],'XTickLabel',[0:500:1500],'YTick',[0:45:180],'YTickLabel',[0:45:180],'FontSize',40);
print(F,'-depsc','Fig8A');

%
F = figure;
A = axes;
hold on;
axis([0 120 -0.2 1.2]);
P = plot(data.wbangle_set{4}(:,end),data.Vs_set{4}(:,5),'k.'); set(P,'MarkerSize',20);
set(A,'XTick',[0:45:90],'XTickLabel',[0:45:90],'YTick',[-0.2:0.2:1.2],'YTickLabel',[-0.2:0.2:1.2],'FontSize',40);
print(F,'-depsc','Fig8B');
