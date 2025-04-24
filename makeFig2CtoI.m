%
clear all
simseed = setrandoms(24060301);

%
ndim = 7;
nsim = 100;
for modeltype = 1:5
    data.Vs_set{modeltype} = NaN(nsim,8);
    data.ds_set{modeltype} = NaN(nsim,8);
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype,ksim);
        [os,xs,Vs,ds] = rnrl1(modeltype,0.1,0.8,ndim,1000,0);
        tmp_last_cue = find(os(1,:),1,'last');
        data.Vs_set{modeltype}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
        data.ds_set{modeltype}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
    end
end
save(['data' num2str(simseed)],'data');

%
tmp_CDEFG = 'CDEFG';
for modeltype = 1:5
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
    print(F,'-depsc',['Fig2' tmp_CDEFG(modeltype)]);
end

%
for modeltype = 3:5
    F = figure;
    A = axes;
    hold on;
    axis([-2 5 -0.5 1.5]);
    P = plot([-2 5],[0 0],'k:');
    for k = 1:nsim
        P = plot([-2:5],data.Vs_set{modeltype}(k,:),'k');
    end
    set(A,'XTick',[-2:5],'XTickLabel',[-2:5],'YTick',[-0.5:0.5:1.5],'YTickLabel',[-0.5:0.5:1.5],'FontSize',40);
    print(F,'-depsc',['Fig2H' num2str(modeltype-2)]);
end

%
simseed = 24060301;
load data24060301
load vd_rnrl1_24070601
true_value = mean(vd.vset(:,5));
for modeltype = 3:5
    F = figure;
    A = axes;
    hold on;
    axis([-0.4 1.8 0 25]);
    H = hist(data.Vs_set{modeltype}(:,5),[-0.3:0.1:1.7]);
    P = bar([-0.3:0.1:1.7],H);
    shading flat
    set(P,'FaceColor',0.5*[1 1 1]);
    P = plot([true_value true_value],[0 25],'k:');
    set(A,'XTick',[0:0.5:1.5],'XTickLabel',[0:0.5:1.5],'YTick',[0:5:25],'YTickLabel',[0:5:25],'FontSize',40);
    set(A,'PlotBoxAspectRatio',[3 1 1]);
    print(F,'-depsc',['Fig2I' num2str(modeltype-2)]);
end
