%
clear all
simseed = setrandoms(25003);

%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
pdist_set = [0 0.1 0.2 0.3];
for k0 = 1:length(pdist_set)
    pdist = pdist_set(k0);
    data{k0}.sqer = NaN(4,length(ndim_set),nsim);
    data{k0}.meanP = NaN(4,length(ndim_set),nsim);
    for k1 = 1:length(ndim_set)
        ndim = ndim_set(k1);
        P_set = NaN(ndim,ndim+3,nsim);
        for modeltype = 3:5
            data{k0}.Vs_set{k1}{modeltype-2} = NaN(nsim,8);
            for ksim = 1:nsim
                fprintf('%d-%d-%d-%d\n',k0,k1,modeltype,ksim);
                [os,xs,Vs,ds,wbcos,P] = rnrl101cosdistlra(modeltype,0.1,0.8,ndim,1500,pdist,[],0);
                if (k1==1) && (modeltype==4) && (ksim==1)
                    os_to_show{k0} = os;
                end
                if modeltype == 4
                    P_set(:,:,ksim) = P;
                end
                tmp_last_cue = find(os(1,:),1,'last');
                data{k0}.Vs_set{k1}{modeltype-2}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
                data{k0}.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
                data{k0}.meanP(modeltype-2,k1,ksim) = mean(mean(P));
            end
        end
        for modeltype = 5
            data{k0}.Vs_set{k1}{modeltype-1} = NaN(nsim,8);
            for ksim = 1:nsim
                fprintf('%d-%d-%d-%d\n',k0,k1,modeltype+1,ksim);
                tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+3),1);
                tmp_P = tmp_P(randperm(ndim*(ndim+3)));
                P = reshape(tmp_P,ndim,ndim+3);
                [os,xs,Vs,ds,wbcos,P] = rnrl101cosdistlra(modeltype,0.1,0.8,ndim,1500,pdist,P,0);
                tmp_last_cue = find(os(1,:),1,'last');
                data{k0}.Vs_set{k1}{modeltype-1}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
                data{k0}.sqer(modeltype-1,k1,ksim) = sum(tmp_error.^2);
                data{k0}.meanP(modeltype-1,k1,ksim) = mean(mean(P));
            end
        end
    end
end
save(['data_tvmakeFig10_' num2str(simseed)],'data');

%
for k0 = 1:length(pdist_set)
    sqer_mean = mean(data{k0}.sqer/4,3);
    sqer_std = std(data{k0}.sqer/4,0,3);
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
    print(F,'-depsc',['Fig10middle-' num2str(k0)]);
end

%
for k = 1:4
    F = figure;
    A = axes;
    hold on;
    P = image(2*os_to_show{k}([2 1 3],1:101));
    colormap([1 1 1;0 0 0]);
    axis([0.5 101.5 0.5 3.5]);
    set(A,'PlotBoxAspectRatio',[3 1 1]);
    set(A,'XTick',[1:50:101],'XTickLabel',[0:50:100],'YTick',[1:3],'YTickLabel',['R';'C';'D'],'FontSize',20);
    print(F,'-depsc',['Fig10left-' num2str(k)]);
end

%
clear all
simseed = setrandoms(25103);
%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim_set = [5:5:40];
nsim = 100;
pdist_set = [0 0.1 0.2 0.3];
for k0 = 1:length(pdist_set)
    pdist = pdist_set(k0);
    data{k0}.sqer = NaN(4,length(ndim_set),nsim);
    data{k0}.meanPe = NaN(4,length(ndim_set),nsim);
    data{k0}.meanPi = NaN(4,length(ndim_set),nsim);
    for k1 = 1:length(ndim_set)
        ndim = ndim_set(k1);
        Pe_set = NaN(ndim,ndim+3,nsim);
        Pi_set = NaN(ndim,ndim+3,nsim);
        for modeltype = 3:5
            data{k0}.Vs_set{k1}{modeltype-2} = NaN(nsim,8);
            for ksim = 1:nsim
                fprintf('%d-%d-%d-%d\n',k0,k1,modeltype,ksim);
                [os,xs,xis,Vs,ds,wbcos,P] = rnrl101coseidistlra(modeltype,0.1,0.8,ndim,1500,pdist,[],0);
                if modeltype == 4
                    Pe_set(:,:,ksim) = P.e;
                    Pi_set(:,:,ksim) = P.i;
                end
                tmp_last_cue = find(os(1,:),1,'last');
                data{k0}.Vs_set{k1}{modeltype-2}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
                data{k0}.sqer(modeltype-2,k1,ksim) = sum(tmp_error.^2);
                data{k0}.meanPe(modeltype-2,k1,ksim) = mean(mean(P.e));
                data{k0}.meanPi(modeltype-2,k1,ksim) = mean(mean(P.i));
            end
        end
        for modeltype = 5
            data{k0}.Vs_set{k1}{modeltype-1} = NaN(nsim,8);
            for ksim = 1:nsim
                fprintf('%d-%d-%d-%d\n',k0,k1,modeltype+1,ksim);
                tmp_Pe = reshape(Pe_set(:,:,ksim),ndim*(ndim+3),1);
                tmp_Pe = tmp_Pe(randperm(ndim*(ndim+3)));
                Pe = reshape(tmp_Pe,ndim,ndim+3);
                tmp_Pi = reshape(Pi_set(:,:,ksim),ndim*(ndim+3),1);
                tmp_Pi = tmp_Pi(randperm(ndim*(ndim+3)));
                Pi = reshape(tmp_Pi,ndim,ndim+3);
                P.e = Pe;
                P.i = Pi;
                [os,xs,xis,Vs,ds,wbcos,P] = rnrl101coseidistlra(modeltype,0.1,0.8,ndim,1500,pdist,P,0);
                tmp_last_cue = find(os(1,:),1,'last');
                data{k0}.Vs_set{k1}{modeltype-1}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
                tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
                data{k0}.sqer(modeltype-1,k1,ksim) = sum(tmp_error.^2);
                data{k0}.meanPe(modeltype-1,k1,ksim) = mean(mean(P.e));
                data{k0}.meanPi(modeltype-1,k1,ksim) = mean(mean(P.i));
            end
        end
    end
end
save(['data_tvmakeFig10ei_' num2str(simseed)],'data');
%
for k0 = 1:length(pdist_set)
    sqer_mean = mean(data{k0}.sqer/4,3);
    sqer_std = std(data{k0}.sqer/4,0,3);
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
    print(F,'-depsc',['Fig10right-' num2str(k0)]);
end
