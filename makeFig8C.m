%
clear all
simseed = setrandoms(24072301);

%
ndim = 12;
nsim = 1000;
P_set = NaN(ndim,ndim+2,nsim);
for modeltype = 4
    data.Vs_set{modeltype} = NaN(nsim,8);
    data.ds_set{modeltype} = NaN(nsim,8);
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype,ksim);
        [os,xs,Vs,ds,wbcos,P] = rnrl101cos(modeltype,0.1,0.8,ndim,500,[],0);
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
save(['data_add2_' num2str(simseed)],'data');


%
simseed = 24072301;
load(['data_add2_' num2str(simseed)]);
for st = 3:6
    rp_set{st} = NaN(499,2);
    for k = 1:499
        [r,p] = corrcoef(data.wbangle_set{4}(:,k+1),data.Vs_set{4}(:,st));
        rp_set{st}(k,:) = [r(1,2),p(1,2)];
    end
end
%
for st = 3:6
    F = figure;
    A = axes;
    hold on;
    axis([0 500.5 -0.25 0.15]);
    P = plot([0 500.5],[0 0],'k:');
    P = plot([2:500],rp_set{st}(:,1),'b');
    tmp = zeros(1,499)./(rp_set{st}(:,2)<0.05);
    for k = 1:499
        if ~isnan(tmp(k))
            P = plot([k+0.5 k+1.5],[0.14 0.14],'k');
        end
    end
    set(A,'XTick',[0:100:500],'XTickLabel',[0:100:500],'YTick',[-0.2:0.1:0.1],'YTickLabel',[-0.2:0.1:0.1]);
    %set(A,'XTickLabelRotationMode','manual','FontName','Arial','FontSize',29); % to 28% -> Font 8.12
    set(A,'FontName','Arial','FontSize',29);
    print(F,'-depsc',['Fig8C' num2str(st-2)]);
end
