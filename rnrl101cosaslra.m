function [os,xs,Vs,ds,wbcos,P,w,pref] = rnrl101cosaslra(modeltype,abase,invt,g,prefdecay,ndim,nt,rmpd,P,plotyn)

% rnrl101cosaslra: action selection
%   modeltype: 3:RevVRNNbp, 4:BioVRNNrf, 5:untrained RNN
%   abase: learning rate base, e.g., 0.1
%   invt: inverse temperature for action selection, e.g., 0.1
%   g: time discount factor, e.g., 0.8
%   prefdecay: decay rate of action preference per time-step, e.g., 0.001
%   ndim: dimension, e.g., 20
%   nt: number of trials, e.g., 3000
%   rmpd: [reward magnitude for action [1 2]; reward probability for action [1 2]; reward delay for action [1 2]], e.g., [2 1; 1 1; 2 1]
%
% 1 2 3 4 5 6 7 8 9 10
% C     R     e e e  e
%
%   [os,xs,Vs,ds,wbcos,P,w,pref] = rnrl101cosaslra(4,0.1,1,0.8,0.001,20,3000,[2 1; 1 1; 2 1],[],0); figure; plot(os(4,:));

ITIs = NaN(1,nt);
cue = [];
rew = [];
act = [];
for k = 1:nt
    tmp = randperm(4);
    ITIs(k) = 2 + tmp(1);
    cue = [cue 1 zeros(1,3+ITIs(k))];
    rew = [rew 0 0 0 0 zeros(1,ITIs(k))];
    act = [act zeros(2,4+ITIs(k))];
end
os = [cue; rew; act]; % observations

if isempty(P)
    P = randn(ndim,ndim+4); % combined A and B
end
w = zeros(1,ndim);
b = rand(1,ndim); % random feedback (non-negative)

pref = zeros(2,ndim); % preference of action 1 and 2

tmax = 4*nt + sum(ITIs);
Vs = NaN(1,tmax);
ds = NaN(1,tmax);
Vs(1) = 0;
xs = NaN(ndim,tmax);
xs(:,1) = rand(ndim,1);
wbcos = NaN(1,tmax);
for t = 2:tmax
    wbcos(t) = sum(w.*b)/(sqrt(sum(w.*w))*sqrt(sum(b.*b)));
    xs(:,t) = 1./(1 + exp(-P*[xs(:,t-1);os(:,t-1)]));
    Vs(t) = w * xs(:,t);
    if cue(t-1) == 1
        tmp_pref = pref * xs(:,t);
        tmp_Pact1 = exp(invt*tmp_pref(1))/sum(exp(invt*tmp_pref));
        tmp_rand = rand;
        if tmp_rand <= tmp_Pact1
            act(1,t) = 1;
            if t+2 <= tmax
                rew(t+rmpd(3,1)) = rmpd(1,1)*(rand <= rmpd(2,1));
            end
        else
            act(2,t) = 1;
            if t+2 <= tmax
                rew(t+rmpd(3,2)) = rmpd(1,2)*(rand <= rmpd(2,2));
            end
        end
        os = [cue; rew; act];
    end
    if t >= 3
        ds(t-1) = rew(t-1) + g*Vs(t) - Vs(t-1);
        wnew = max(0, w + (abase/(ndim/12))*ds(t-1)*xs(:,t-1)');
        if cue(t-2) == 1
            pref(2-(act(1,t-1)>act(2,t-1)),:) = max(0, pref(2-(act(1,t-1)>act(2,t-1)),:) + (abase/(ndim/12))*ds(t-1)*xs(:,t-1)');
        end
        if modeltype == 3
            P = P + abase*ds(t-1)*(xs(:,t-1).*(1-xs(:,t-1)).*w')*[xs(:,t-2);os(:,t-2)]';
        elseif modeltype == 4
            %P = P + abase*ds(t-1)*(xs(:,t-1).*(1-xs(:,t-1)).*b')*[xs(:,t-2);os(:,t-2)]';
            y = (xs(:,t-1)<0.5).*xs(:,t-1).*(1-xs(:,t-1)) + (xs(:,t-1)>=0.5)*0.5*0.5;
            P = P + abase*ds(t-1)*(y.*b')*[xs(:,t-2);os(:,t-2)]';
        end
        w = wnew;
        pref = pref * (1 - prefdecay);
    end
end
if plotyn
    figure;
    subplot(3,1,1); hold on; plot(Vs(end-50:end),'k'); plot(ds(end-50:end),'r');
    subplot(3,1,2); hold on; plot(cue(end-50:end),'b'); plot(rew(end-50:end),'g');
    subplot(3,1,3); hold on; plot(acos(wbcos)*(180/pi));
end
