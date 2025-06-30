% makeFigA2

%
clear all
simseed = setrandoms(25060500);
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
pp_set = [3/4, 2/3, 3/5, 1/2];
data.sqer = NaN(6,length(ndim_set),nsim);
data.meanP = NaN(6,length(ndim_set),nsim);
for k1 = 1:length(ndim_set)
    ndim = ndim_set(k1);
    P_set = NaN(ndim,ndim+2,nsim);
    for modeltype = 4
        data.Vs_set{k1}{1} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,1,ksim);
            [os,xs,Vs,ds,wbcos,P] = oVRNN_BTSP1(modeltype,1,0.1,0.8,0,ndim,1500,[],0);
            if modeltype == 4
                P_set(:,:,ksim) = P;
            end
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{1}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(1,k1,ksim) = sum(tmp_error.^2);
            data.meanP(1,k1,ksim) = mean(mean(P));
        end
    end
    for modeltype = 5
        data.Vs_set{k1}{2} = NaN(nsim,8);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,2,ksim);
            tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+2),1);
            tmp_P = tmp_P(randperm(ndim*(ndim+2)));
            P = reshape(tmp_P,ndim,ndim+2);
            [os,xs,Vs,ds,wbcos,P] = oVRNN_BTSP1(modeltype,1,0.1,0.8,0,ndim,1500,P,0);
            tmp_last_cue = find(os(1,:),1,'last');
            data.Vs_set{k1}{2}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(2,k1,ksim) = sum(tmp_error.^2);
            data.meanP(2,k1,ksim) = mean(mean(P));
        end
    end
    for modeltype = 6
        for k_pp = 1:length(pp_set)
            pp = pp_set(k_pp);
            data.Vs_set{k1}{2+k_pp} = NaN(nsim,8);
            for ksim = 1:nsim
                fprintf('%d-%d-%d\n',k1,2+k_pp,ksim);
                [os,xs,Vs,ds,wbcos,P] = oVRNN_BTSP1(modeltype,pp,0.1,0.8,decay_rate,ndim,1500,[],0);
                tmp_last_cue = find(os(1,:),1,'last');
                data.Vs_set{k1}{2+k_pp}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
                data.sqer(2+k_pp,k1,ksim) = sum(tmp_error.^2);
                data.meanP(2+k_pp,k1,ksim) = mean(mean(P));
            end
        end
    end
end
save('data_run_oVRNN_BTSP1_25060500','data');

%
nsim = 100;
load('data_run_oVRNN_BTSP1_25060500');
%
sqer_mean = mean(data.sqer/4,3);
sqer_std = std(data.sqer/4,0,3);
tmp_colors = [
    0   0   0;
    0.5 0.5 0.5;
    1   0   1;
    2/3 1/3 1;
    1/3 2/3 1;
    0   1   1];
nsim = 100;
F = figure;
A = axes;
hold on;
axis([0 45 0 1/4]);
for k = [2 1 3 4 5 6]
    P1 = errorbar([5:5:40],sqer_mean(k,:),sqer_std(k,:)/sqrt(nsim),'--');
    P2 = plot([5:5:40],sqer_mean(k,:));
    set(P1,'Color',tmp_colors(k,:)); set(P2,'Color',tmp_colors(k,:));
    if k == 2
        set(P2,'LineStyle','--');
    end
end
set(A,'XTick',[5:5:40],'XTickLabel',[5:5:40],'YTick',[0:0.05:0.25],'YTickLabel',[0:0.05:0.25],'FontSize',40);
print(F,'-depsc','FigA2');
