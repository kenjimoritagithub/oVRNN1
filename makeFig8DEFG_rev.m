%
clear all
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
simseed1 = setrandoms(24071201);
%
ndim = 12;
nsim = 100;
data.sqer = NaN(3,nsim);
data.w_set{1} = NaN(nsim,ndim);
for modeltype = 3:4
    if modeltype == 4
        data.Vs_set{1} = NaN(nsim,8);
        data.ds_set{1} = NaN(nsim,8);
    end
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype,ksim);
        [os,xs,Vs,ds,w,wbcos,P] = rnrl101cosdeclra(modeltype,0.1,0.8,0,ndim,1500,[],0);
        if modeltype == 4
            data.w_set{1}(ksim,:) = w;
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{1}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            data.ds_set{1}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
            tmp_cue = find(os(1,:));
            data.wbangle_set{1}(ksim,:) = acos(wbcos(tmp_cue))*(180/pi);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(1,ksim) = mean(tmp_error.^2);
        end
    end
end
%
simseed2 = setrandoms(26011);
%
modeltype = 4;
dr_set = [0.001:0.001:0.002];
for kdr = 1:length(dr_set)
    data.w_set{kdr+1} = NaN(nsim,ndim);
    data.Vs_set{kdr+1} = NaN(nsim,8);
    data.ds_set{kdr+1} = NaN(nsim,8);
    for ksim = 1:nsim
        fprintf('%d-%d\n',kdr,ksim);
        [os,xs,Vs,ds,w,wbcos,P] = rnrl101cosdeclra(modeltype,0.1,0.8,dr_set(kdr),ndim,1500,[],0);
        data.w_set{kdr+1}(ksim,:) = w;
        tmp_last_cue = find(os(1,:),1,'last');
        data.Vs_set{kdr+1}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
        data.ds_set{kdr+1}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
        tmp_cue = find(os(1,:));
        data.wbangle_set{kdr+1}(ksim,:) = acos(wbcos(tmp_cue))*(180/pi);
        tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
        data.sqer(kdr+1,ksim) = mean(tmp_error.^2);
    end
end
save(['data_tvmakeFig8DEFG_' num2str(simseed1) '_' num2str(simseed2)],'data');

%
simseed3 = setrandoms(26012);
nsim2 = 10000;
angle_set = NaN(3,nsim2);
z1 = zeros(ndim,1); z1(1) = 1;
z2 = zeros(ndim,1); z2(1:2) = 1;
for k = 1:10000
    x = rand(ndim,1);
    y = rand(ndim,1);
    xycos = sum(x.*y)/(sqrt(sum(x.*x))*sqrt(sum(y.*y)));
    angle_set(1,k) = acos(xycos)*(180/pi);
    xz1cos = sum(x.*z1)/(sqrt(sum(x.*x))*sqrt(sum(z1.*z1)));
    angle_set(2,k) = acos(xz1cos)*(180/pi);
    xz2cos = sum(x.*z2)/(sqrt(sum(x.*x))*sqrt(sum(z2.*z2)));
    angle_set(3,k) = acos(xz2cos)*(180/pi);
end
F = figure;
A = axes;
hold on;
for k = 1:3
    subplot(3,1,k);
    hist(angle_set(k,:),[1.5:3:88.5]);
    set(gca,'YLim',[0 1500],'XTick',[0:15:90],'XTickLabel',[],'YTick',[0:500:1500],'YTickLabel',[]);
    shading flat
end
print(F,'-depsc','Fig8D');

%
for k1 = 1:3
    w_sort{k1} = NaN(nsim,ndim);
    for ksim = 1:nsim
        w_sort{k1}(ksim,:) = sort(data.w_set{k1}(ksim,:),'descend');
    end
    F = figure;
    A = axes;
    hold on;
    axis([0 13 0 2]);
    P = bar([1:12],mean(w_sort{k1},1)); set(P,'FaceColor',0.5*[1 1 1],'EdgeColor','none');
    P = errorbar([1:12],mean(w_sort{k1},1),std(w_sort{k1},0,1)/sqrt(nsim),'k.');
    set(A,'XTick',[1:ndim],'XTickLabel',[],'YTick',[0:0.5:2],'YTickLabel',[],'FontSize',40);
    print(F,'-depsc',['Fig8E_' num2str(k1)]);
end

%
for kdr = 2:3
    F = figure;
    A = axes;
    hold on;
    axis([0 1500 -10 190]);
    P = plot([0 1500],[0 0],'k:');
    P = plot([0 1500],[180 180],'k:');
    P = plot([0 1500],[90 90],'r');
    P = plot([0 1500],[45 45],'k-.');
    P = plot([1:1500],mean(data.wbangle_set{kdr},1)+std(data.wbangle_set{kdr},0,1),'k--'); % SD (rather than SEM)
    P = plot([1:1500],mean(data.wbangle_set{kdr},1)-std(data.wbangle_set{kdr},0,1),'k--'); % SD (rather than SEM)
    P = plot([1:1500],mean(data.wbangle_set{kdr},1),'k');
    set(A,'XTick',[0:500:1500],'XTickLabel',[],'YTick',[0:45:180],'YTickLabel',[],'FontSize',40);
    print(F,'-depsc',['Fig8F_' num2str(kdr)]);
end

%
sqer_mean = mean(data.sqer,2);
sqer_std = std(data.sqer,0,2);
F = figure;
A = axes;
hold on;
axis([-0.5 2.5 0 1/4]);
P = errorbar([0:2],sqer_mean,sqer_std/sqrt(nsim),'k--');
P = plot([0:2],sqer_mean,'k');
set(A,'XTick',[0:2],'XTickLabel',[],'YTick',[0:0.05:0.25],'YTickLabel',[],'FontSize',40);
print(F,'-depsc','Fig8G');
