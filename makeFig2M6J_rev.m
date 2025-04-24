%%  simulation of cue-reward association task with various delays

%
clear all
simseed = setrandoms(25012);

%
load('data_corrected_truevalue_30001.mat');
g = 0.8;
CRdur_set = [3:6];
for CRdur = CRdur_set
    vtrue = tv{CRdur}(3:3+CRdur);
    ndim_set = [5:5:40];
    nsim = 100;
    meansqer1{CRdur} = NaN(3,length(ndim_set),nsim);
    for k1 = 1:length(ndim_set)
        ndim = ndim_set(k1);
        for modeltype = 3:5
            for ksim = 1:nsim
                fprintf('%d-%d-%d-%d\n',CRdur,k1,modeltype,ksim);
                [os,xs,Vs,ds,wbcos] = rnrl1cosCRdurlra(modeltype,CRdur,0.1,g,ndim,3000,0);
                tmp_last_cue = find(os(1,:),1,'last');
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+CRdur);
                meansqer1{CRdur}(modeltype-2,k1,ksim) = mean(tmp_error.^2);
            end
        end
    end
end
save(['data_tvmakeFig2M_meansqer1_' num2str(simseed)],'meansqer1');

%
clear all
simseed = setrandoms(25021);
%
load('data_corrected_truevalue_30001.mat');
g = 0.8;
CRdur_set = [3:6];
for CRdur = CRdur_set
    vtrue = tv{CRdur}(3:3+CRdur);
    ndim_set = [5:5:40];
    nsim = 100;
    meansqer101{CRdur} = NaN(4,length(ndim_set),nsim);
    for k1 = 1:length(ndim_set)
        ndim = ndim_set(k1);
        P_set = NaN(ndim,ndim+2,nsim);
        for modeltype = 3:5
            for ksim = 1:nsim
                fprintf('%d-%d-%d-%d\n',CRdur,k1,modeltype,ksim);
                [os,xs,Vs,ds,wbcos,P] = rnrl101cosCRdurlra(modeltype,CRdur,0.1,g,ndim,3000,[],0);
                if modeltype == 4
                    P_set(:,:,ksim) = P;
                end
                tmp_last_cue = find(os(1,:),1,'last');
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+CRdur);
                meansqer101{CRdur}(modeltype-2,k1,ksim) = mean(tmp_error.^2);
            end
        end
        for modeltype = 5
            for ksim = 1:nsim
                fprintf('%d-%d-%d-%d\n',CRdur,k1,modeltype+1,ksim);
                tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+2),1);
                tmp_P = tmp_P(randperm(ndim*(ndim+2)));
                P = reshape(tmp_P,ndim,ndim+2);
                [os,xs,Vs,ds,wbcos,P] = rnrl101cosCRdurlra(modeltype,CRdur,0.1,g,ndim,3000,P,0);
                tmp_last_cue = find(os(1,:),1,'last');
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+CRdur);
                meansqer101{CRdur}(modeltype-1,k1,ksim) = mean(tmp_error.^2);
            end
        end
    end
end
save(['data_tvmakeFig6I1_meansqer101_' num2str(simseed)],'meansqer101');
%
clear all
simseed = setrandoms(25022);
%
load('data_corrected_truevalue_30001.mat');
g = 0.8;
CRdur_set = [3:6];
for CRdur = CRdur_set
    vtrue = tv{CRdur}(3:3+CRdur);
    ndim_set = [5:5:40];
    nsim = 100;
    meansqer101{CRdur} = NaN(4,length(ndim_set),nsim);
    for k1 = 1:length(ndim_set)
        ndim = ndim_set(k1);
        P_set = NaN(ndim,ndim+2,nsim);
        for modeltype = 3:5
            for ksim = 1:nsim
                fprintf('%d-%d-%d-%d\n',CRdur,k1,modeltype,ksim);
                [os,xs,Vs,ds,wbcos,P] = rnrl101cosCRdurlra(modeltype,CRdur,0.05,g,ndim,3000,[],0);
                if modeltype == 4
                    P_set(:,:,ksim) = P;
                end
                tmp_last_cue = find(os(1,:),1,'last');
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+CRdur);
                meansqer101{CRdur}(modeltype-2,k1,ksim) = mean(tmp_error.^2);
            end
        end
        for modeltype = 5
            for ksim = 1:nsim
                fprintf('%d-%d-%d-%d\n',CRdur,k1,modeltype+1,ksim);
                tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+2),1);
                tmp_P = tmp_P(randperm(ndim*(ndim+2)));
                P = reshape(tmp_P,ndim,ndim+2);
                [os,xs,Vs,ds,wbcos,P] = rnrl101cosCRdurlra(modeltype,CRdur,0.05,g,ndim,3000,P,0);
                tmp_last_cue = find(os(1,:),1,'last');
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+CRdur);
                meansqer101{CRdur}(modeltype-1,k1,ksim) = mean(tmp_error.^2);
            end
        end
    end
end
save(['data_tvmakeFig6I2_meansqer101_' num2str(simseed)],'meansqer101');

%
CRdur_set = [3:6];
for CRdur = CRdur_set
    sqer_mean = mean(meansqer1{CRdur},3);
    sqer_std = std(meansqer1{CRdur},0,3);
    tmp_colors = 'rby';
    nsim = 100;
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
    print(F,'-depsc',['Fig2M_' num2str(CRdur)]);
end

%
load data_tvmakeFig6I1_meansqer101_25021
CRdur_set = [3:6];
for CRdur = CRdur_set
    sqer_mean = mean(meansqer101{CRdur},3);
    sqer_std = std(meansqer101{CRdur},0,3);
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
    print(F,'-depsc',['Fig6J1_' num2str(CRdur)]);
end

%
load data_tvmakeFig6I2_meansqer101_25022
CRdur_set = [3:6];
for CRdur = CRdur_set
    sqer_mean = mean(meansqer101{CRdur},3);
    sqer_std = std(meansqer101{CRdur},0,3);
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
    print(F,'-depsc',['Fig6J2_' num2str(CRdur)]);
end
