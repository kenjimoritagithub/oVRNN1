%
clear all
simseed = setrandoms(25001);

%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
data.sqer = NaN(4,length(ndim_set),nsim);
data.meanPe = NaN(4,length(ndim_set),nsim);
data.meanPi = NaN(4,length(ndim_set),nsim);
for k1 = 1:length(ndim_set)
    ndim = ndim_set(k1);
    Pe_set = NaN(ndim,ndim+2,nsim);
    Pi_set = NaN(ndim,ndim+2,nsim);
    for modeltype = 3:5
        data.Vs_set{k1}{modeltype-2} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,xis,Vs,ds,wbcos,P] = rnrl101coseilra(modeltype,0.1,0.8,ndim,1500,[],0);
            if modeltype == 4
                Pe_set(:,:,ksim) = P.e;
                Pi_set(:,:,ksim) = P.i;
            end
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype-2}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
            data.meanPe(modeltype-2,k1,ksim) = mean(mean(P.e));
            data.meanPi(modeltype-2,k1,ksim) = mean(mean(P.i));
        end
    end
    for modeltype = 5
        data.Vs_set{k1}{modeltype-1} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype+1,ksim);
            tmp_Pe = reshape(Pe_set(:,:,ksim),ndim*(ndim+2),1);
            tmp_Pe = tmp_Pe(randperm(ndim*(ndim+2)));
            Pe = reshape(tmp_Pe,ndim,ndim+2);
            tmp_Pi = reshape(Pi_set(:,:,ksim),ndim*(ndim+2),1);
            tmp_Pi = tmp_Pi(randperm(ndim*(ndim+2)));
            Pi = reshape(tmp_Pi,ndim,ndim+2);
            P.e = Pe;
            P.i = Pi;
            [os,xs,xis,Vs,ds,wbcos,P] = rnrl101coseilra(modeltype,0.1,0.8,ndim,1500,P,0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{modeltype-1}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-1,k1,ksim) = sum(tmp_error.^2);
            data.meanPe(modeltype-1,k1,ksim) = mean(mean(P.e));
            data.meanPi(modeltype-1,k1,ksim) = mean(mean(P.i));
        end
    end
end
save(['data_tvmakeFig9B_' num2str(simseed)],'data');

%
sqer_mean = mean(data.sqer/4,3);
sqer_std = std(data.sqer/4,0,3);
tmp_colors = 'rbym';
nsim = 100;
F = figure;
A = axes;
hold on;
axis([0 45 0 0.25]);
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
print(F,'-depsc','Fig9B');
