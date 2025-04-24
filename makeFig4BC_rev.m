%
clear all
simseed = setrandoms(30002);

%
nt = 1000;
nsim = 10000;
g = 0.8;

%
tasktype = 1;

%
tv.trtype{tasktype}{1} = zeros(1,9);
for k_initITI = 1:4
    v1{k_initITI} = NaN(nsim,5+k_initITI+1);
    for ksim = 1:nsim
        fprintf('%d-%d-%d-%d\n',tasktype,1,k_initITI,ksim);
        ITIs = NaN(1,nt);
        trialtypes = [];
        cue = [];
        rew = [];
        for k = 1:nt
            if k == 1
                ITIs(k) = 1 + k_initITI;
            else
                tmp = randperm(4);
                ITIs(k) = 1 + tmp(1);
            end
            cue = [cue 1 zeros(1,4+ITIs(k))];
            if k == 1
                rew = [rew 0 0 1 0 0 zeros(1,ITIs(k))];
                trialtypes = [trialtypes 1 zeros(1,4+ITIs(k))];
            else
                tmpR = rand(1,2);
                if (tmpR(1) <= 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 1 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 1 zeros(1,4+ITIs(k))];
                elseif (tmpR(1) > 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 0 0 1 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 2 zeros(1,4+ITIs(k))];
                else
                    rew = [rew 0 0 0 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 3 zeros(1,4+ITIs(k))];
                end
            end
        end
        rew_initomit = rew; rew_initomit(3) = 0;
        v1{k_initITI}(ksim,1:2) = sum(g.^(find(rew)-(2+1))) * (g.^[2-1:-1:0]);
        v1{k_initITI}(ksim,2+1:end) = sum(g.^(find(rew_initomit)-(2+1))) * (g.^[-1:-1:-(k_initITI+4)]);
    end
end
tmptv_towards_cue = zeros(4,3);
% state value at [cue-2 cue-1 cue] when ITI was 3
for k_initITI = 1:4
    tmptv_towards_cue(1,:) = tmptv_towards_cue(1,:) + mean(v1{k_initITI}(:,3+[2:4]),1)/4;
end
% state value at [cue-2 cue-1 cue] when ITI was 4
for k_initITI = 1:4
    tmptv_towards_cue(2,1:2) = tmptv_towards_cue(2,1:2) + mean(v1{k_initITI}(:,3+[3:4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(2,3) = tmptv_towards_cue(2,3) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
% state value at [cue-2 cue-1 cue] when ITI was 5
for k_initITI = 1:4
    tmptv_towards_cue(3,1) = tmptv_towards_cue(3,1) + mean(v1{k_initITI}(:,3+[4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(3,2) = tmptv_towards_cue(3,2) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(3,3) = tmptv_towards_cue(3,3) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
% state value at [cue-2 cue-1 cue] when ITI was 6
for k_initITI = 2:4
    tmptv_towards_cue(4,1) = tmptv_towards_cue(4,1) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(4,2) = tmptv_towards_cue(4,2) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
tmptv_towards_cue(4,3) = mean(v1{4}(:,3+[7]),1);
tv.trtype{tasktype}{1}(1:3) = mean(tmptv_towards_cue,1);
for k_initITI = 1:4
    tv.trtype{tasktype}{1}(4:end) = tv.trtype{tasktype}{1}(4:end) + mean(v1{k_initITI}(:,1:6),1)/4;
end

%
tv.trtype{tasktype}{2} = zeros(1,9);
for k_initITI = 1:4
    v1{k_initITI} = NaN(nsim,5+k_initITI+1);
    for ksim = 1:nsim
        fprintf('%d-%d-%d-%d\n',tasktype,2,k_initITI,ksim);
        ITIs = NaN(1,nt);
        trialtypes = [];
        cue = [];
        rew = [];
        for k = 1:nt
            if k == 1
                ITIs(k) = 1 + k_initITI;
            else
                tmp = randperm(4);
                ITIs(k) = 1 + tmp(1);
            end
            cue = [cue 1 zeros(1,4+ITIs(k))];
            if k == 1
                rew = [rew 0 0 0 0 1 zeros(1,ITIs(k))];
                trialtypes = [trialtypes 2 zeros(1,4+ITIs(k))];
            else
                tmpR = rand(1,2);
                if (tmpR(1) <= 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 1 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 1 zeros(1,4+ITIs(k))];
                elseif (tmpR(1) > 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 0 0 1 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 2 zeros(1,4+ITIs(k))];
                else
                    rew = [rew 0 0 0 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 3 zeros(1,4+ITIs(k))];
                end
            end
        end
        rew_initomit = rew; rew_initomit(5) = 0;
        v1{k_initITI}(ksim,1:4) = sum(g.^(find(rew)-(4+1))) * (g.^[4-1:-1:0]);
        v1{k_initITI}(ksim,4+1:end) = sum(g.^(find(rew_initomit)-(4+1))) * (g.^[-1:-1:-(k_initITI+2)]);
    end
end
tmptv_towards_cue = zeros(4,3);
% state value at [cue-2 cue-1 cue] when ITI was 3
for k_initITI = 1:4
    tmptv_towards_cue(1,:) = tmptv_towards_cue(1,:) + mean(v1{k_initITI}(:,3+[2:4]),1)/4;
end
% state value at [cue-2 cue-1 cue] when ITI was 4
for k_initITI = 1:4
    tmptv_towards_cue(2,1:2) = tmptv_towards_cue(2,1:2) + mean(v1{k_initITI}(:,3+[3:4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(2,3) = tmptv_towards_cue(2,3) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
% state value at [cue-2 cue-1 cue] when ITI was 5
for k_initITI = 1:4
    tmptv_towards_cue(3,1) = tmptv_towards_cue(3,1) + mean(v1{k_initITI}(:,3+[4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(3,2) = tmptv_towards_cue(3,2) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(3,3) = tmptv_towards_cue(3,3) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
% state value at [cue-2 cue-1 cue] when ITI was 6
for k_initITI = 2:4
    tmptv_towards_cue(4,1) = tmptv_towards_cue(4,1) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(4,2) = tmptv_towards_cue(4,2) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
tmptv_towards_cue(4,3) = mean(v1{4}(:,3+[7]),1);
tv.trtype{tasktype}{2}(1:3) = mean(tmptv_towards_cue,1);
for k_initITI = 1:4
    tv.trtype{tasktype}{2}(4:end) = tv.trtype{tasktype}{2}(4:end) + mean(v1{k_initITI}(:,1:6),1)/4;
end

%
tv.state{tasktype}{1} = [0.5*tv.trtype{tasktype}{1}(1:5)+0.5*tv.trtype{tasktype}{2}(1:5) tv.trtype{tasktype}{1}(6:9)];
tv.state{tasktype}{2} = [0.5*tv.trtype{tasktype}{1}(1:5)+0.5*tv.trtype{tasktype}{2}(1:5) tv.trtype{tasktype}{2}(6:9)];

%
tasktype = 2;

%
tv.trtype{tasktype}{1} = zeros(1,9);
for k_initITI = 1:4
    v1{k_initITI} = NaN(nsim,5+k_initITI+1);
    for ksim = 1:nsim
        fprintf('%d-%d-%d-%d\n',tasktype,1,k_initITI,ksim);
        ITIs = NaN(1,nt);
        trialtypes = [];
        cue = [];
        rew = [];
        for k = 1:nt
            if k == 1
                ITIs(k) = 1 + k_initITI;
            else
                tmp = randperm(4);
                ITIs(k) = 1 + tmp(1);
            end
            cue = [cue 1 zeros(1,4+ITIs(k))];
            if k == 1
                rew = [rew 0 0 1 0 0 zeros(1,ITIs(k))];
                trialtypes = [trialtypes 1 zeros(1,4+ITIs(k))];
            else
                tmpR = rand(1,2);
                if (tmpR(1) <= 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 1 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 1 zeros(1,4+ITIs(k))];
                elseif (tmpR(1) > 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 0 0 1 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 2 zeros(1,4+ITIs(k))];
                else
                    rew = [rew 0 0 0 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 3 zeros(1,4+ITIs(k))];
                end
            end
        end
        rew_initomit = rew; rew_initomit(3) = 0;
        v1{k_initITI}(ksim,1:2) = sum(g.^(find(rew)-(2+1))) * (g.^[2-1:-1:0]);
        v1{k_initITI}(ksim,2+1:end) = sum(g.^(find(rew_initomit)-(2+1))) * (g.^[-1:-1:-(k_initITI+4)]);
    end
end
tmptv_towards_cue = zeros(4,3);
% state value at [cue-2 cue-1 cue] when ITI was 3
for k_initITI = 1:4
    tmptv_towards_cue(1,:) = tmptv_towards_cue(1,:) + mean(v1{k_initITI}(:,3+[2:4]),1)/4;
end
% state value at [cue-2 cue-1 cue] when ITI was 4
for k_initITI = 1:4
    tmptv_towards_cue(2,1:2) = tmptv_towards_cue(2,1:2) + mean(v1{k_initITI}(:,3+[3:4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(2,3) = tmptv_towards_cue(2,3) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
% state value at [cue-2 cue-1 cue] when ITI was 5
for k_initITI = 1:4
    tmptv_towards_cue(3,1) = tmptv_towards_cue(3,1) + mean(v1{k_initITI}(:,3+[4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(3,2) = tmptv_towards_cue(3,2) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(3,3) = tmptv_towards_cue(3,3) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
% state value at [cue-2 cue-1 cue] when ITI was 6
for k_initITI = 2:4
    tmptv_towards_cue(4,1) = tmptv_towards_cue(4,1) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(4,2) = tmptv_towards_cue(4,2) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
tmptv_towards_cue(4,3) = mean(v1{4}(:,3+[7]),1);
tv.trtype{tasktype}{1}(1:3) = mean(tmptv_towards_cue,1);
for k_initITI = 1:4
    tv.trtype{tasktype}{1}(4:end) = tv.trtype{tasktype}{1}(4:end) + mean(v1{k_initITI}(:,1:6),1)/4;
end

%
tv.trtype{tasktype}{2} = zeros(1,9);
for k_initITI = 1:4
    v1{k_initITI} = NaN(nsim,5+k_initITI+1);
    for ksim = 1:nsim
        fprintf('%d-%d-%d-%d\n',tasktype,2,k_initITI,ksim);
        ITIs = NaN(1,nt);
        trialtypes = [];
        cue = [];
        rew = [];
        for k = 1:nt
            if k == 1
                ITIs(k) = 1 + k_initITI;
            else
                tmp = randperm(4);
                ITIs(k) = 1 + tmp(1);
            end
            cue = [cue 1 zeros(1,4+ITIs(k))];
            if k == 1
                rew = [rew 0 0 0 0 1 zeros(1,ITIs(k))];
                trialtypes = [trialtypes 2 zeros(1,4+ITIs(k))];
            else
                tmpR = rand(1,2);
                if (tmpR(1) <= 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 1 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 1 zeros(1,4+ITIs(k))];
                elseif (tmpR(1) > 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 0 0 1 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 2 zeros(1,4+ITIs(k))];
                else
                    rew = [rew 0 0 0 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 3 zeros(1,4+ITIs(k))];
                end
            end
        end
        rew_initomit = rew; rew_initomit(5) = 0;
        v1{k_initITI}(ksim,1:4) = sum(g.^(find(rew)-(4+1))) * (g.^[4-1:-1:0]);
        v1{k_initITI}(ksim,4+1:end) = sum(g.^(find(rew_initomit)-(4+1))) * (g.^[-1:-1:-(k_initITI+2)]);
    end
end
tmptv_towards_cue = zeros(4,3);
% state value at [cue-2 cue-1 cue] when ITI was 3
for k_initITI = 1:4
    tmptv_towards_cue(1,:) = tmptv_towards_cue(1,:) + mean(v1{k_initITI}(:,3+[2:4]),1)/4;
end
% state value at [cue-2 cue-1 cue] when ITI was 4
for k_initITI = 1:4
    tmptv_towards_cue(2,1:2) = tmptv_towards_cue(2,1:2) + mean(v1{k_initITI}(:,3+[3:4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(2,3) = tmptv_towards_cue(2,3) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
% state value at [cue-2 cue-1 cue] when ITI was 5
for k_initITI = 1:4
    tmptv_towards_cue(3,1) = tmptv_towards_cue(3,1) + mean(v1{k_initITI}(:,3+[4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(3,2) = tmptv_towards_cue(3,2) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(3,3) = tmptv_towards_cue(3,3) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
% state value at [cue-2 cue-1 cue] when ITI was 6
for k_initITI = 2:4
    tmptv_towards_cue(4,1) = tmptv_towards_cue(4,1) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(4,2) = tmptv_towards_cue(4,2) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
tmptv_towards_cue(4,3) = mean(v1{4}(:,3+[7]),1);
tv.trtype{tasktype}{2}(1:3) = mean(tmptv_towards_cue,1);
for k_initITI = 1:4
    tv.trtype{tasktype}{2}(4:end) = tv.trtype{tasktype}{2}(4:end) + mean(v1{k_initITI}(:,1:6),1)/4;
end

%
tv.trtype{tasktype}{3} = zeros(1,9);
for k_initITI = 1:4
    v1{k_initITI} = NaN(nsim,5+k_initITI+1);
    for ksim = 1:nsim
        fprintf('%d-%d-%d-%d\n',tasktype,3,k_initITI,ksim);
        ITIs = NaN(1,nt);
        trialtypes = [];
        cue = [];
        rew = [];
        for k = 1:nt
            if k == 1
                ITIs(k) = 1 + k_initITI;
            else
                tmp = randperm(4);
                ITIs(k) = 1 + tmp(1);
            end
            cue = [cue 1 zeros(1,4+ITIs(k))];
            if k == 1
                rew = [rew 0 0 0 0 0 zeros(1,ITIs(k))];
                trialtypes = [trialtypes 3 zeros(1,4+ITIs(k))];
            else
                tmpR = rand(1,2);
                if (tmpR(1) <= 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 1 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 1 zeros(1,4+ITIs(k))];
                elseif (tmpR(1) > 0.5) && ((tasktype==1) || ((tasktype==2)&&(tmpR(2) <= 0.6)))
                    rew = [rew 0 0 0 0 1 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 2 zeros(1,4+ITIs(k))];
                else
                    rew = [rew 0 0 0 0 0 zeros(1,ITIs(k))];
                    trialtypes = [trialtypes 3 zeros(1,4+ITIs(k))];
                end
            end
        end
        v1{k_initITI}(ksim,1:4) = sum(g.^(find(rew)-(4+1))) * (g.^[4-1:-1:0]);
        v1{k_initITI}(ksim,4+1:end) = sum(g.^(find(rew)-(4+1))) * (g.^[-1:-1:-(k_initITI+2)]);
    end
end
tmptv_towards_cue = zeros(4,3);
% state value at [cue-2 cue-1 cue] when ITI was 3
for k_initITI = 1:4
    tmptv_towards_cue(1,:) = tmptv_towards_cue(1,:) + mean(v1{k_initITI}(:,3+[2:4]),1)/4;
end
% state value at [cue-2 cue-1 cue] when ITI was 4
for k_initITI = 1:4
    tmptv_towards_cue(2,1:2) = tmptv_towards_cue(2,1:2) + mean(v1{k_initITI}(:,3+[3:4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(2,3) = tmptv_towards_cue(2,3) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
% state value at [cue-2 cue-1 cue] when ITI was 5
for k_initITI = 1:4
    tmptv_towards_cue(3,1) = tmptv_towards_cue(3,1) + mean(v1{k_initITI}(:,3+[4]),1)/4;
end
for k_initITI = 2:4
    tmptv_towards_cue(3,2) = tmptv_towards_cue(3,2) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(3,3) = tmptv_towards_cue(3,3) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
% state value at [cue-2 cue-1 cue] when ITI was 6
for k_initITI = 2:4
    tmptv_towards_cue(4,1) = tmptv_towards_cue(4,1) + mean(v1{k_initITI}(:,3+[5]),1)/3;
end
for k_initITI = 3:4
    tmptv_towards_cue(4,2) = tmptv_towards_cue(4,2) + mean(v1{k_initITI}(:,3+[6]),1)/2;
end
tmptv_towards_cue(4,3) = mean(v1{4}(:,3+[7]),1);
tv.trtype{tasktype}{3}(1:3) = mean(tmptv_towards_cue,1);
for k_initITI = 1:4
    tv.trtype{tasktype}{3}(4:end) = tv.trtype{tasktype}{3}(4:end) + mean(v1{k_initITI}(:,1:6),1)/4;
end

%
tv.state{tasktype}{1} = [0.3*tv.trtype{tasktype}{1}(1:5)+0.3*tv.trtype{tasktype}{2}(1:5)+0.4*tv.trtype{tasktype}{3}(1:5) tv.trtype{tasktype}{1}(6:9)];
tv.state{tasktype}{2} = [0.3*tv.trtype{tasktype}{1}(1:5)+0.3*tv.trtype{tasktype}{2}(1:5)+0.4*tv.trtype{tasktype}{3}(1:5)...
    (3/7)*tv.trtype{tasktype}{2}(6:7)+(4/7)*tv.trtype{tasktype}{3}(6:7) tv.trtype{tasktype}{2}(8:9)];
tv.state{tasktype}{3} = [0.3*tv.trtype{tasktype}{1}(1:5)+0.3*tv.trtype{tasktype}{2}(1:5)+0.4*tv.trtype{tasktype}{3}(1:5)...
    (3/7)*tv.trtype{tasktype}{2}(6:7)+(4/7)*tv.trtype{tasktype}{3}(6:7) tv.trtype{tasktype}{3}(8:9)];

%
save(['data_corrected_truevalue_probtask_' num2str(simseed)],'tv');

%
load data_corrected_truevalue_probtask_30002

%
F = figure;
A = axes;
hold on;
axis([1 9 0 1.5]);
P = plot([4:9],tv.trtype{1}{1}(4:9),'r');
P = plot([4:8],tv.trtype{1}{2}(4:8),'b'); P = plot([8:9],tv.trtype{1}{2}(8:9),'b--');
set(A,'PlotBoxAspectRatio',[4 1 1]);
set(A,'XTick',[1:9],'YTick',[0:0.5:1.5],'XTickLabel',[],'YTickLabel',[]);
print(F,'-depsc','Fig4Ba1');

%
F = figure;
A = axes;
hold on;
axis([1 9 0 1.5]);
P = plot([4:9],tv.trtype{2}{1}(4:9),'r');
P = plot([4:8],tv.trtype{2}{2}(4:8),'b'); P = plot([8:9],tv.trtype{2}{2}(8:9),'b--');
P = plot([4:6],tv.trtype{2}{3}(4:6),'g'); P = plot([6:9],tv.trtype{2}{3}(6:9),'g:'); 
set(A,'PlotBoxAspectRatio',[4 1 1]);
set(A,'XTick',[1:9],'YTick',[0:0.5:1.5],'XTickLabel',[],'YTickLabel',[]);
print(F,'-depsc','Fig4Ba2');

%
F = figure;
A = axes;
hold on;
axis([1 9 0 1.5]);
P = plot([1:9],tv.state{1}{1},'m');
P = plot([1:5],tv.state{1}{2}(1:5),'k'); P = plot([5:8],tv.state{1}{2}(5:8),'c'); P = plot([8:9],tv.state{1}{2}(8:9),'c:');
set(A,'PlotBoxAspectRatio',[4 1 1]);
set(A,'XTick',[1:9],'YTick',[0:0.5:1.5],'XTickLabel',[],'YTickLabel',[]);
print(F,'-depsc','Fig4Bc1');

%
F = figure;
A = axes;
hold on;
axis([1 9 0 1.5]);
P = plot([1:9],tv.state{2}{1},'m');
P = plot([1:5],tv.state{2}{2}(1:5),'c'); P = plot([5:8],tv.state{2}{2}(5:8),'c'); P = plot([8:9],tv.state{2}{2}(8:9),'c--');
P = plot([1:5],tv.state{2}{3}(1:5),'k'); P = plot([5:8],tv.state{2}{3}(5:8),'k--'); P = plot([8:9],tv.state{2}{3}(8:9),'k:');
set(A,'PlotBoxAspectRatio',[4 1 1]);
set(A,'XTick',[1:9],'YTick',[0:0.5:1.5],'XTickLabel',[],'YTickLabel',[]);
print(F,'-depsc','Fig4Bc2');

%
RPE1 = [0 0 0 0 1 0 0 0] + 0.8*tv.state{1}{1}(2:end) - tv.state{1}{1}(1:end-1);
RPE2 = [0 0 0 0 0 0 1 0] + 0.8*tv.state{1}{2}(2:end) - tv.state{1}{2}(1:end-1);
F = figure;
A = axes;
hold on;
axis([-2 5 -0.6 0.8]);
P = plot([-2 5],[0 0],'k:');
P = plot([-2:5],RPE1,'r');
P = plot([-2:1],RPE2(1:4),'b--'); P = plot([1:3],RPE2(4:6),'b'); P = plot([3:5],RPE2(6:end),'b--');
set(A,'XTick',[-2:5],'YTick',[-0.6:0.2:0.8],'FontSize',40);
print(F,'-depsc','Fig4C1');

%
RPE1 = [0 0 0 0 1 0 0 0] + 0.8*tv.state{2}{1}(2:end) - tv.state{2}{1}(1:end-1);
RPE2 = [0 0 0 0 0 0 1 0] + 0.8*tv.state{2}{2}(2:end) - tv.state{2}{2}(1:end-1);
F = figure;
A = axes;
hold on;
axis([-2 5 -0.6 0.8]);
P = plot([-2 5],[0 0],'k:');
P = plot([-2:5],RPE1,'r');
P = plot([-2:1],RPE2(1:4),'b--'); P = plot([1:5],RPE2(4:end),'b');
set(A,'XTick',[-2:5],'YTick',[-0.6:0.2:0.8],'FontSize',40);
print(F,'-depsc','Fig4C2');
