%% Fig. 2J

%
clear all
simseed = setrandoms(24001);
%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
data.sqer = NaN(3,length(ndim_set),nsim);
for k1 = 1:length(ndim_set)
    ndim = ndim_set(k1);
    for modeltype = 3:5
        data.Vs_set{k1}{modeltype} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,Vs,ds] = rnrl1lra(modeltype,0.1,0.8,ndim,1000,0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
        end
    end
end
save(['data_tvmakeFig2Jleft_' num2str(simseed)],'data');

%
clear all
simseed = setrandoms(24002);
%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
data.sqer = NaN(3,length(ndim_set),nsim);
for k1 = 1:length(ndim_set)
    ndim = ndim_set(k1);
    for modeltype = 4
        data.Vs_set{k1}{modeltype} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,Vs,ds] = rnrl1oneslra(0.1,0.8,ndim,1000,0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
        end
    end
end
save(['data_tvmakeFig2Jright_' num2str(simseed)],'data');

%
load data_tvmakeFig2Jright_24002
data2 = data;
clear data
load data_tvmakeFig2Jleft_24001
nsim = 100;
%
sqer_mean = mean(data.sqer/4,3);
sqer_std = std(data.sqer/4,0,3);
tmp_colors = 'rby';
F = figure;
A = axes;
hold on;
axis([0 45 0 2.5/4]);
for k = 1:3
    P1 = errorbar([5:5:40],sqer_mean(k,:),sqer_std(k,:)/sqrt(nsim),[tmp_colors(k) '--']);
    P2 = plot([5:5:40],sqer_mean(k,:),tmp_colors(k));
    if k == 3
        set(P1,'Color',0.5*[1 1 1]);
        set(P2,'Color',0.5*[1 1 1]);
    end
end
set(A,'XTick',[5:5:40],'XTickLabel',[5:5:40],'YTick',[0:0.1:0.6],'YTickLabel',[0:0.1:0.6],'FontSize',40);
print(F,'-depsc','Fig2Jleft');
%
sqer_mean2 = mean(data2.sqer/4,3);
sqer_std2 = std(data2.sqer/4,0,3);
F = figure;
A = axes;
hold on;
axis([0 45 0 2.5/4]);
for k = 2
    P = errorbar([5:5:40],sqer_mean(k,:),sqer_std(k,:)/sqrt(nsim),[tmp_colors(k) '--']);
    P = plot([5:5:40],sqer_mean(k,:),tmp_colors(k));
end
for k = 2
    P = errorbar([5:5:40],sqer_mean2(k,:),sqer_std2(k,:)/sqrt(nsim),'g--');
    P = plot([5:5:40],sqer_mean2(k,:),'g');
end
set(A,'XTick',[5:5:40],'XTickLabel',[5:5:40],'YTick',[0:0.1:0.6],'YTickLabel',[0:0.1:0.6],'FontSize',40);
print(F,'-depsc','Fig2Jright');


%% Fig. 6E

%
clear all
simseed = setrandoms(24011);
%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
data.sqer = NaN(4,length(ndim_set),nsim);
data.meanP = NaN(4,length(ndim_set),nsim);
for k1 = 1:length(ndim_set)
    ndim = ndim_set(k1);
    P_set = NaN(ndim,ndim+2,nsim);
    for modeltype = 3:5
        data.Vs_set{k1}{modeltype-2} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,Vs,ds,wbcos,P] = rnrl101coslra(modeltype,0.1,0.8,ndim,1500,[],0);
            if modeltype == 4
                P_set(:,:,ksim) = P;
            end
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype-2}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
            data.meanP(modeltype-2,k1,ksim) = mean(mean(P));
        end
    end
    for modeltype = 5
        data.Vs_set{k1}{modeltype-1} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype+1,ksim);
            tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+2),1);
            tmp_P = tmp_P(randperm(ndim*(ndim+2)));
            P = reshape(tmp_P,ndim,ndim+2);
            [os,xs,Vs,ds,wbcos,P] = rnrl101coslra(modeltype,0.1,0.8,ndim,1500,P,0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype-1}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-1,k1,ksim) = sum(tmp_error.^2);
            data.meanP(modeltype-1,k1,ksim) = mean(mean(P));
        end
    end
end
save(['data_tvmakeFig6Eleft_' num2str(simseed)],'data');

%
clear all
simseed = setrandoms(24012);
%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
data.sqer = NaN(4,length(ndim_set),nsim);
data.meanP = NaN(4,length(ndim_set),nsim);
for k1 = 1:length(ndim_set)
    ndim = ndim_set(k1);
    for modeltype = 4
        data.Vs_set{k1}{modeltype-2} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,Vs,ds,wbcos,P] = rnrl101cosoneslra(0.1,0.8,ndim,1500,[],0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype-2}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
            data.meanP(modeltype-2,k1,ksim) = mean(mean(P));
        end
    end
end
save(['data_tvmakeFig6Eright1_' num2str(simseed)],'data');

%
clear all
simseed = setrandoms(24013);
%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
data.sqer = NaN(4,length(ndim_set),nsim);
data.meanP = NaN(4,length(ndim_set),nsim);
for k1 = 1:length(ndim_set)
    ndim = ndim_set(k1);
    for modeltype = 4
        data.Vs_set{k1}{modeltype-2} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,Vs,ds,wbcos,P] = rnrl101cosones2lra(0.1,0.8,ndim,1500,[],0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype-2}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
            data.meanP(modeltype-2,k1,ksim) = mean(mean(P));
        end
    end
end
save(['data_tvmakeFig6Eright2_' num2str(simseed)],'data');

%
clear all
simseed = setrandoms(24014);
%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
data.sqer = NaN(4,length(ndim_set),nsim);
data.meanP = NaN(4,length(ndim_set),nsim);
for k1 = 1:length(ndim_set)
    ndim = ndim_set(k1);
    for modeltype = 4
        data.Vs_set{k1}{modeltype-2} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,Vs,ds,wbcos,P] = rnrl101cosnmlra(6,0.1,0.8,ndim,1500,[],0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype-2}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
            data.meanP(modeltype-2,k1,ksim) = mean(mean(P));
        end
    end
end
save(['data_tvmakeFig6Eright3_' num2str(simseed)],'data');

%
load data_tvmakeFig6Eright1_24012
data2 = data;
clear data
load data_tvmakeFig6Eright2_24013
data3 = data;
clear data
load data_tvmakeFig6Eright3_24014
data4 = data;
clear data
load data_tvmakeFig6Eleft_24011
nsim = 100;
%
sqer_mean = mean(data.sqer/4,3);
sqer_std = std(data.sqer/4,0,3);
tmp_colors = 'rbym';
nsim = 100;
F = figure;
A = axes;
hold on;
axis([0 45 0 1/4]);
for k = 1:4
    P1 = errorbar([5:5:40],sqer_mean(k,:),sqer_std(k,:)/sqrt(nsim),[tmp_colors(k) '--']);
    P2 = plot([5:5:40],sqer_mean(k,:),tmp_colors(k));
    if k == 3
        set(P1,'Color',0.5*[1 1 1]);
        set(P2,'Color',0.5*[1 1 1]);
    elseif k == 4
        set(P1,'Color',0.5*[1 1 1]);
        set(P2,'Color',0.5*[1 1 1]);
        set(P2,'LineStyle','--');
    end
end
set(A,'XTick',[5:5:40],'XTickLabel',[5:5:40],'YTick',[0:0.05:0.25],'YTickLabel',[0:0.05:0.25],'FontSize',40);
print(F,'-depsc','Fig6Eleft');
%
sqer_mean2 = mean(data2.sqer/4,3);
sqer_std2 = std(data2.sqer/4,0,3);
sqer_mean3 = mean(data3.sqer/4,3);
sqer_std3 = std(data3.sqer/4,0,3);
sqer_mean4 = mean(data4.sqer/4,3);
sqer_std4 = std(data4.sqer/4,0,3);
F = figure;
A = axes;
hold on;
axis([0 45 0 1/4]);
for k = 2
    P = errorbar([5:5:40],sqer_mean(k,:),sqer_std(k,:)/sqrt(nsim),[tmp_colors(k) '--']);
    P = plot([5:5:40],sqer_mean(k,:),tmp_colors(k));
end
for k = 2
    P = errorbar([5:5:40],sqer_mean2(k,:),sqer_std2(k,:)/sqrt(nsim),'g--');
    P = plot([5:5:40],sqer_mean2(k,:),'g');
end
for k = 2
    P = errorbar([5:5:40],sqer_mean3(k,:),sqer_std3(k,:)/sqrt(nsim),'c--');
    P = plot([5:5:40],sqer_mean3(k,:),'c');
end
for k = 2
    P = errorbar([5:5:40],sqer_mean4(k,:),sqer_std4(k,:)/sqrt(nsim),'b--');
    P = plot([5:5:40],sqer_mean4(k,:),'b--');
end
set(A,'XTick',[5:5:40],'XTickLabel',[5:5:40],'YTick',[0:0.05:0.25],'YTickLabel',[0:0.05:0.25],'FontSize',40);
print(F,'-depsc','Fig6Eright');

%
load data_tvmakeFig6Eright1_24012
data2 = data;
clear data
load data_tvmakeFig6Eright2_24013
data3 = data;
clear data
load data_tvmakeFig6Eright3_24014
data4 = data;
clear data
load data_tvmakeFig6Eleft_24011
nsim = 100;
%
meanP_mean = mean(data.meanP,3);
meanP_std = std(data.meanP,0,3);
tmp_colors = 'rbym';
nsim = 100;
F = figure;
A = axes;
hold on;
axis([0 45 -0.4 0.1]);
P = plot([0 45],[0 0],'k:');
for k = 1:3
    P1 = errorbar([5:5:40],meanP_mean(k,:),meanP_std(k,:)/sqrt(nsim),[tmp_colors(k) '--']);
    P2 = plot([5:5:40],meanP_mean(k,:),tmp_colors(k));
    if k == 3
        set(P1,'Color',0.5*[1 1 1]);
        set(P2,'Color',0.5*[1 1 1]);
    end
end
set(A,'XTick',[5:5:40],'XTickLabel',[5:5:40],'YTick',[-0.4:0.1:0.1],'YTickLabel',[-0.4:0.1:0.1]);
%set(A,'XTickLabelRotationMode','manual','FontName','Arial','FontSize',29);
set(A,'FontName','Arial','FontSize',29);
print(F,'-depsc','Fig6Fleft');
%
meanP_mean2 = mean(data2.meanP,3);
meanP_std2 = std(data2.meanP,0,3);
meanP_mean3 = mean(data3.meanP,3);
meanP_std3 = std(data3.meanP,0,3);
meanP_mean4 = mean(data4.meanP,3);
meanP_std4 = std(data4.meanP,0,3);
F = figure;
A = axes;
hold on;
axis([0 45 -0.4 0.1]);
P = plot([0 45],[0 0],'k:');
for k = 2
    P = errorbar([5:5:40],meanP_mean(k,:),meanP_std(k,:)/sqrt(nsim),[tmp_colors(k) '--']);
    P = plot([5:5:40],meanP_mean(k,:),tmp_colors(k));
end
for k = 2
    P = errorbar([5:5:40],meanP_mean2(k,:),meanP_std2(k,:)/sqrt(nsim),'g--');
    P = plot([5:5:40],meanP_mean2(k,:),'g');
end
for k = 2
    P = errorbar([5:5:40],meanP_mean3(k,:),meanP_std3(k,:)/sqrt(nsim),'c--');
    P = plot([5:5:40],meanP_mean3(k,:),'c');
end
for k = 2
    P = errorbar([5:5:40],meanP_mean4(k,:),meanP_std4(k,:)/sqrt(nsim),'b--');
    P = plot([5:5:40],meanP_mean4(k,:),'b--');
end
set(A,'XTick',[5:5:40],'XTickLabel',[5:5:40],'YTick',[-0.4:0.1:0.1],'YTickLabel',[-0.4:0.1:0.1]);
%set(A,'XTickLabelRotationMode','manual','FontName','Arial','FontSize',29);
set(A,'FontName','Arial','FontSize',29);
print(F,'-depsc','Fig6Fright');
