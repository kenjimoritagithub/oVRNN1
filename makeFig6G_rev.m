%% Fig. 6G

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
        data.ds_set{k1}{modeltype-2} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,Vs,ds,wbcos,P] = rnrl101coslra(modeltype,0.1,0.8,ndim,1500,[],0);
            if modeltype == 4
                P_set(:,:,ksim) = P;
            end
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype-2}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            data.ds_set{k1}{modeltype-2}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
            data.meanP(modeltype-2,k1,ksim) = mean(mean(P));
        end
    end
    for modeltype = 5
        data.Vs_set{k1}{modeltype-1} = NaN(nsim,8);
        data.ds_set{k1}{modeltype-1} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype+1,ksim);
            tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+2),1);
            tmp_P = tmp_P(randperm(ndim*(ndim+2)));
            P = reshape(tmp_P,ndim,ndim+2);
            [os,xs,Vs,ds,wbcos,P] = rnrl101coslra(modeltype,0.1,0.8,ndim,1500,P,0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype-1}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            data.ds_set{k1}{modeltype-1}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-1,k1,ksim) = sum(tmp_error.^2);
            data.meanP(modeltype-1,k1,ksim) = mean(mean(P));
        end
    end
end
save(['data_tvmakeFig6Eleft_ds_' num2str(simseed)],'data');

%
k1 = 8;
F = figure;
A = axes;
hold on;
axis([-2 5 -0.5 1.5]);
P = plot([-2 5],[0 0],'k:');
P = plot([-2:5],tv{3}(1:end-1),'k');
modeltype = 3-2;
P = errorbar([-2:5],mean(data.Vs_set{k1}{modeltype},1),std(data.Vs_set{k1}{modeltype},0,1)/sqrt(nsim),'r--');
P = plot([-2:5],mean(data.Vs_set{k1}{modeltype},1),'r');
modeltype = 4-2;
P = errorbar([-2:5],mean(data.Vs_set{k1}{modeltype},1),std(data.Vs_set{k1}{modeltype},0,1)/sqrt(nsim),'b--');
P = plot([-2:5],mean(data.Vs_set{k1}{modeltype},1),'b');
set(A,'XTick',[-2:5],'XTickLabel',[-2:5],'YTick',[-0.5:0.5:1.5],'YTickLabel',[-0.5:0.5:1.5],'FontSize',40);
print(F,'-depsc','Fig6G_V');

%
k1 = 8;
F = figure;
A = axes;
hold on;
axis([-2 5 -0.1 0.2]);
P = plot([-2 5],[0 0],'k:');
true_RPE = [0 0 0 0 0 1 0 0] + 0.8*tv{3}(2:end) - tv{3}(1:end-1);
P = plot([-2:5],true_RPE,'k');
modeltype = 3-2;
P = errorbar([-2:5],mean(data.ds_set{k1}{modeltype},1),std(data.ds_set{k1}{modeltype},0,1)/sqrt(nsim),'r--');
P = plot([-2:5],mean(data.ds_set{k1}{modeltype},1),'r');
modeltype = 4-2;
P = errorbar([-2:5],mean(data.ds_set{k1}{modeltype},1),std(data.ds_set{k1}{modeltype},0,1)/sqrt(nsim),'b--');
P = plot([-2:5],mean(data.ds_set{k1}{modeltype},1),'b');
set(A,'XTick',[-2:5],'XTickLabel',[-2:5],'YTick',[-0.1:0.1:0.2],'YTickLabel',[-0.1:0.1:0.2],'FontSize',40);
print(F,'-depsc','Fig6G_d');
