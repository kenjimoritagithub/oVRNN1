%% Fig. 2L

%
clear all
simseed = setrandoms(26001);
%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim = 20;
t_set = [100:100:3000];
nsim = 100;
data.sqer = NaN(3,length(t_set),nsim);
for modeltype = 3:5
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype,ksim);
        out = rnrl1lra_every100(modeltype,0.1,0.8,ndim,3000,0);
        for k_t = 1:30
            os = out{k_t}.os;
            xs = out{k_t}.xs;
            Vs = out{k_t}.Vs;
            ds = out{k_t}.ds;
            tmp_last_cue = find(os(1,:),1,'last');
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k_t,ksim) = mean(tmp_error.^2);
        end
    end
end
save(['data_tvmakeFig2L_' num2str(simseed)],'data');

%
nsim = 100;
%
sqer_mean = mean(data.sqer,3);
sqer_std = std(data.sqer,0,3);
tmp_colors = 'rby';
F = figure;
A = axes;
hold on;
axis([0 30 0 2.5/4]);
for k = 1:3
    P1 = errorbar([1:30],sqer_mean(k,:),sqer_std(k,:)/sqrt(nsim),[tmp_colors(k) '--']);
    P2 = plot([1:30],sqer_mean(k,:),tmp_colors(k));
    if k == 3
        set(P1,'Color',0.5*[1 1 1]);
        set(P2,'Color',0.5*[1 1 1]);
    end
end
set(A,'XTick',[10:10:30],'XTickLabel',[],'YTick',[0:0.1:0.6],'YTickLabel',[0:0.1:0.6],'FontSize',40);
print(F,'-depsc','Fig2L');


%% Fig.6I

%
clear all
simseed = setrandoms(26002);
%
load('data_corrected_truevalue_30001.mat');
vtrue = tv{3}(3:6);
ndim = 20;
t_set = [100:100:3000];
nsim = 100;
data.sqer = NaN(4,length(t_set),nsim);
P_set = NaN(ndim,ndim+2,nsim);
for modeltype = 3:5
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype,ksim);
        out = rnrl101coslra_every100(modeltype,0.1,0.8,ndim,3000,[],0);
        for k_t = 1:30
            os = out{k_t}.os;
            xs = out{k_t}.xs;
            Vs = out{k_t}.Vs;
            ds = out{k_t}.ds;
            wbcos = out{k_t}.wbcos;
            P = out{k_t}.P;
            if (modeltype == 4) && (k_t == 30)
                P_set(:,:,ksim) = P;
            end
            tmp_last_cue = find(os(1,:),1,'last');
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-2,k_t,ksim) = mean(tmp_error.^2);
        end
    end
end
for modeltype = 5
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype+1,ksim);
        tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+2),1);
        tmp_P = tmp_P(randperm(ndim*(ndim+2)));
        P = reshape(tmp_P,ndim,ndim+2);
        out = rnrl101coslra_every100(modeltype,0.1,0.8,ndim,3000,P,0);
        for k_t = 1:30
            os = out{k_t}.os;
            xs = out{k_t}.xs;
            Vs = out{k_t}.Vs;
            ds = out{k_t}.ds;
            wbcos = out{k_t}.wbcos;
            P = out{k_t}.P;
            tmp_last_cue = find(os(1,:),1,'last');
            tmp_error = vtrue - Vs(tmp_last_cue:tmp_last_cue+3);
            data.sqer(modeltype-1,k_t,ksim) = mean(tmp_error.^2);
        end
    end
end
save(['data_tvmakeFig6H_' num2str(simseed)],'data');

%
nsim = 100;
%
sqer_mean = mean(data.sqer,3);
sqer_std = std(data.sqer,0,3);
tmp_colors = 'rbym';
nsim = 100;
F = figure;
A = axes;
hold on;
axis([0 30 0 1/4]);
for k = 1:4
    P1 = errorbar([1:30],sqer_mean(k,:),sqer_std(k,:)/sqrt(nsim),[tmp_colors(k) '--']);
    P2 = plot([1:30],sqer_mean(k,:),tmp_colors(k));
    if k == 3
        set(P1,'Color',0.5*[1 1 1]);
        set(P2,'Color',0.5*[1 1 1]);
    elseif k == 4
        set(P1,'Color',0.5*[1 1 1]);
        set(P2,'Color',0.5*[1 1 1]);
        set(P2,'LineStyle','--');
    end
end
set(A,'XTick',[10:10:30],'XTickLabel',[],'YTick',[0:0.05:0.25],'YTickLabel',[0:0.05:0.25],'FontSize',40);
print(F,'-depsc','Fig6I');
