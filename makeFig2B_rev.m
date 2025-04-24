% true state values of cue-reward association task with various delays

%
clear all
simseed = setrandoms(30001);

%
nt = 1000;
nsim = 1000;
g = 0.8;
CRdur_set = [3:6];
for CRdur = CRdur_set
    tv{CRdur} = zeros(1,CRdur+6);
    for k_initITI = 1:4
        v1{CRdur}{k_initITI} = NaN(nsim,CRdur+2+k_initITI+1);
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',CRdur,k_initITI,ksim);
            ITIs = NaN(1,nt);
            cue = [];
            rew = [];
            for k = 1:nt
                if k == 1
                    ITIs(k) = 2 + k_initITI;
                else
                    tmp = randperm(4);
                    ITIs(k) = 2 + tmp(1);
                end
                cue = [cue 1 zeros(1,CRdur+ITIs(k))];
                rew = [rew zeros(1,CRdur) 1 zeros(1,ITIs(k))];
            end
            rew_initomit = rew; rew_initomit(CRdur+1) = 0;
            v1{CRdur}{k_initITI}(ksim,1:CRdur) = sum(g.^(find(rew)-(CRdur+1))) * (g.^[CRdur-1:-1:0]);
            v1{CRdur}{k_initITI}(ksim,CRdur+1:end) = sum(g.^(find(rew_initomit)-(CRdur+1))) * (g.^[-1:-1:-(k_initITI+3)]);
        end
    end
    tmptv_towards_cue = zeros(4,3);
    % state value at [cue-2 cue-1 cue] when ITI was 4
    for k_initITI = 1:4
        tmptv_towards_cue(1,:) = tmptv_towards_cue(1,:) + mean(v1{CRdur}{k_initITI}(:,CRdur+[2:4]),1)/4;
    end
    % state value at [cue-2 cue-1 cue] when ITI was 5
    for k_initITI = 1:4
        tmptv_towards_cue(2,1:2) = tmptv_towards_cue(2,1:2) + mean(v1{CRdur}{k_initITI}(:,CRdur+[3:4]),1)/4;
    end
    for k_initITI = 2:4
        tmptv_towards_cue(2,3) = tmptv_towards_cue(2,3) + mean(v1{CRdur}{k_initITI}(:,CRdur+[5]),1)/3;
    end
    % state value at [cue-2 cue-1 cue] when ITI was 6
    for k_initITI = 1:4
        tmptv_towards_cue(3,1) = tmptv_towards_cue(3,1) + mean(v1{CRdur}{k_initITI}(:,CRdur+[4]),1)/4;
    end
    for k_initITI = 2:4
        tmptv_towards_cue(3,2) = tmptv_towards_cue(3,2) + mean(v1{CRdur}{k_initITI}(:,CRdur+[5]),1)/3;
    end
    for k_initITI = 3:4
        tmptv_towards_cue(3,3) = tmptv_towards_cue(3,3) + mean(v1{CRdur}{k_initITI}(:,CRdur+[6]),1)/2;
    end
    % state value at [cue-2 cue-1 cue] when ITI was 7
    for k_initITI = 2:4
        tmptv_towards_cue(4,1) = tmptv_towards_cue(4,1) + mean(v1{CRdur}{k_initITI}(:,CRdur+[5]),1)/3;
    end
    for k_initITI = 3:4
        tmptv_towards_cue(4,2) = tmptv_towards_cue(4,2) + mean(v1{CRdur}{k_initITI}(:,CRdur+[6]),1)/2;
    end
    tmptv_towards_cue(4,3) = mean(v1{CRdur}{4}(:,CRdur+[7]),1);
    tv{CRdur}(1:3) = mean(tmptv_towards_cue,1);
    for k_initITI = 1:4
        tv{CRdur}(4:end) = tv{CRdur}(4:end) + mean(v1{CRdur}{k_initITI}(:,1:CRdur+3),1)/4;
    end
end
save(['data_corrected_truevalue_' num2str(simseed)],'tv');

%
load data_corrected_truevalue_30001
RPE = [0 0 0 0 0 1 0 0] + 0.8*tv{3}(2:end) - tv{3}(1:end-1);
F = figure;
A = axes;
hold on;
axis([-2 5 -0.5 1.5]);
P = plot([-2 5],[0 0],'k:');
P = plot([-2:5],tv{3}(1:end-1),'k');
P = plot([-2:5],RPE,'r');
set(A,'XTick',[-2:5],'XTickLabel',[-2:5],'YTick',[-0.5:0.5:1.5],'YTickLabel',[-0.5:0.5:1.5],'FontSize',40);
print(F,'-depsc','Fig2B');
