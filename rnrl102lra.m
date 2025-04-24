function [os,xs,Vs,ds,trialtypes,P] = rnrl102lra(modeltype,tasktype,abase,g,ndim,nt,P,plotyn)

% rnrl102lra
%   modeltype: 1:punctate(w/o continuation), 2:punctate, 3:RevVRNNbp, 4:BioVRNNrf, 5:untrained RNN
%   tasktype: 1:reward is always given at time3 or time5, 2:reward is omitted in 40% of trials
%   abase: learning rate base, e.g., 0.1
%   g: time discount factor, e.g., 0.8
%   ndim: dimension, e.g., 20
%   nt: number of trials, e.g., 2000
%
% 1 2 3 4 5 6 7 8 9 10
% C   r   r   e e e  e
%
%   [os,xs,Vs,ds,trialtypes,P] = rnrl102lra(4,1,0.1,0.8,20,2000,[],1);

if (modeltype == 1) || (modeltype == 2)
    ndim = 10;
end

ITIs = NaN(1,nt);
trialtypes = [];
cue = [];
rew = [];
states = [];
stateM = eye(10);
for k = 1:nt
    tmp = randperm(4);
    ITIs(k) = 1 + tmp(1);
    cue = [cue 1 zeros(1,4+ITIs(k))];
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
    states = [states stateM(:,1:5+ITIs(k))];
end
os = [cue; rew]; % observations

if isempty(P)
    P = randn(ndim,ndim+2); % combined A and B
end
w = zeros(1,ndim);
b = rand(1,ndim); % random feedback (non-negative)

tmax = 5*nt + sum(ITIs);
Vs = NaN(1,tmax);
ds = NaN(1,tmax);
Vs(1) = 0;
xs = NaN(ndim,tmax);
xs(:,1) = rand(ndim,1);
if (modeltype == 1) || (modeltype == 2)
    xs = [stateM(:,end) states(:,1:end-1)];
end
for t = 2:tmax
    if (modeltype == 3) || (modeltype == 4) || (modeltype == 5)
        xs(:,t) = 1./(1 + exp(-P*[xs(:,t-1);os(:,t-1)]));
    end
    Vs(t) = w * xs(:,t);
    if t >= 3
        ds(t-1) = rew(t-1) + g*Vs(t) - Vs(t-1);
        if ((modeltype == 1) && (xs(1,t) == 1))
            wnew = w;
        else
            wnew = max(0, w + (abase/(ndim/12))*ds(t-1)*xs(:,t-1)');
        end
        if modeltype == 3
            P = P + abase*ds(t-1)*(xs(:,t-1).*(1-xs(:,t-1)).*w')*[xs(:,t-2);os(:,t-2)]';
        elseif modeltype == 4
            %P = P + abase*ds(t-1)*(xs(:,t-1).*(1-xs(:,t-1)).*b')*[xs(:,t-2);os(:,t-2)]';
            y = (xs(:,t-1)<0.5).*xs(:,t-1).*(1-xs(:,t-1)) + (xs(:,t-1)>=0.5)*0.5*0.5;
            P = P + abase*ds(t-1)*(y.*b')*[xs(:,t-2);os(:,t-2)]';
        end
        w = wnew;
    end
end
if plotyn
    figure;
    subplot(2,1,1); hold on; plot(Vs(end-50:end),'k'); plot(ds(end-50:end),'r');
    subplot(2,1,2); hold on; plot(cue(end-50:end),'b'); plot(rew(end-50:end),'g');
end
