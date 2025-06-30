% makeFigA1

%%
%
clear all
simseed = setrandoms(250603);

%
load('data_corrected_truevalue_30001.mat');
g = 0.8;
eta_set = [0.1:0.1:0.8];
for k_eta = 1:length(eta_set)
    eta = eta_set(k_eta);
    CRdur_set = [6];
    for CRdur = CRdur_set
        vtrue = tv{CRdur}(3:3+CRdur);
        ndim_set = [40];
        nsim = 1000;
        meansqer101{k_eta}{CRdur} = NaN(4,length(ndim_set),nsim);
        for k1 = 1:length(ndim_set)
            ndim = ndim_set(k1);
            for modeltype = 3:4
                for ksim = 1:nsim
                    fprintf('%d-%d-%d-%d-%d\n',k_eta,CRdur,k1,modeltype,ksim);
                    [os,xs,Vs,ds,wbcos,P] = rnrl101cosCRdurlraeli(modeltype,CRdur,0.1,g,ndim,3000,[],eta,0);
                    tmp_last_cue = find(os(1,:),1,'last');
                    tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+CRdur);
                    meansqer101{k_eta}{CRdur}(modeltype-2,k1,ksim) = mean(tmp_error.^2);
                end
            end
        end
    end
end
save(['data_test_eli1_long_' num2str(simseed)],'meansqer101');

%
CRdur = 6;
eta_set = [0.1:0.1:0.8];
tmp_sqer_mean_set = NaN(2,length(eta_set)+1);
tmp_sqer_sem_set = NaN(2,length(eta_set)+1);
load('data_tvmakeFig6I1_meansqer101_25021');
nsim = 100;
sqer_mean = mean(meansqer101{6}(1:2,end,:),3);
sqer_std = std(meansqer101{6}(1:2,end,:),0,3);
tmp_sqer_mean_set(:,1) = sqer_mean(1:2,1);
tmp_sqer_sem_set(:,1) = sqer_std(1:2,1)/sqrt(nsim);
clear meansqer101
load data_test_eli1_long_250603
nsim = 1000;
for k_eta = 1:length(eta_set)
    sqer_mean = mean(meansqer101{k_eta}{CRdur},3);
    sqer_std = std(meansqer101{k_eta}{CRdur},0,3);
    tmp_sqer_mean_set(:,k_eta+1) = sqer_mean(1:2,1);
    tmp_sqer_sem_set(:,k_eta+1) = sqer_std(1:2,1)/sqrt(nsim);
end
%
F = figure;
A = axes;
hold on;
axis([0 0.8 0 0.07]);
P = errorbar([0 eta_set],tmp_sqer_mean_set(1,:),tmp_sqer_sem_set(1,:),'r--');
P = plot([0 eta_set],tmp_sqer_mean_set(1,:),'r');
P = errorbar([0 eta_set],tmp_sqer_mean_set(2,:),tmp_sqer_sem_set(2,:),'b--');
P = plot([0 eta_set],tmp_sqer_mean_set(2,:),'b');
set(A,'XTick',[0:0.1:0.8],'XTickLabel',[],'YTick',[0:0.01:0.07],'YTickLabel',[0:0.01:0.07],'FontSize',40);
print(F,'-depsc','FigA1left');

%%
%
clear all
simseed = setrandoms(250604);

%
load('data_corrected_truevalue_30001.mat');
g = 0.8;
eta_set = [0.1:0.1:0.8];
for k_eta = 1:length(eta_set)
    eta = eta_set(k_eta);
    CRdur_set = [6];
    for CRdur = CRdur_set
        vtrue = tv{CRdur}(3:3+CRdur);
        ndim_set = [40];
        nsim = 1000;
        meansqer101{k_eta}{CRdur} = NaN(4,length(ndim_set),nsim);
        for k1 = 1:length(ndim_set)
            ndim = ndim_set(k1);
            for modeltype = 3:4
                for ksim = 1:nsim
                    fprintf('%d-%d-%d-%d-%d\n',k_eta,CRdur,k1,modeltype,ksim);
                    [os,xs,Vs,ds,wbcos,P] = rnrl101cosCRdurlraeli(modeltype,CRdur,0.05,g,ndim,3000,[],eta,0);
                    tmp_last_cue = find(os(1,:),1,'last');
                    tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+CRdur);
                    meansqer101{k_eta}{CRdur}(modeltype-2,k1,ksim) = mean(tmp_error.^2);
                end
            end
        end
    end
end
save(['data_test_eli1_lrhalved_long_' num2str(simseed)],'meansqer101');

%
CRdur = 6;
eta_set = [0.1:0.1:0.8];
tmp_sqer_mean_set = NaN(2,length(eta_set)+1);
tmp_sqer_sem_set = NaN(2,length(eta_set)+1);
load('data_tvmakeFig6I2_meansqer101_25022');
nsim = 100;
sqer_mean = mean(meansqer101{6}(1:2,end,:),3);
sqer_std = std(meansqer101{6}(1:2,end,:),0,3);
tmp_sqer_mean_set(:,1) = sqer_mean(1:2,1);
tmp_sqer_sem_set(:,1) = sqer_std(1:2,1)/sqrt(nsim);
clear meansqer101
load data_test_eli1_250601
nsim = 1000;
for k_eta = 1:length(eta_set)
    sqer_mean = mean(meansqer101{k_eta}{CRdur},3);
    sqer_std = std(meansqer101{k_eta}{CRdur},0,3);
    tmp_sqer_mean_set(:,k_eta+1) = sqer_mean(1:2,1);
    tmp_sqer_sem_set(:,k_eta+1) = sqer_std(1:2,1)/sqrt(nsim);
end
%
F = figure;
A = axes;
hold on;
axis([0 0.8 0 0.07]);
P = errorbar([0 eta_set],tmp_sqer_mean_set(1,:),tmp_sqer_sem_set(1,:),'r--');
P = plot([0 eta_set],tmp_sqer_mean_set(1,:),'r');
P = errorbar([0 eta_set],tmp_sqer_mean_set(2,:),tmp_sqer_sem_set(2,:),'b--');
P = plot([0 eta_set],tmp_sqer_mean_set(2,:),'b');
set(A,'XTick',[0:0.1:0.8],'XTickLabel',[],'YTick',[0:0.01:0.07],'YTickLabel',[0:0.01:0.07],'FontSize',40);
print(F,'-depsc','FigA1right');
