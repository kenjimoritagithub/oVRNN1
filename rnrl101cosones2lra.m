function [os,xs,Vs,ds,wbcos,P] = rnrl101cosones2lra(abase,g,ndim,nt,P,plotyn)

% rnrl101cosones2lra: feedback 0.5*(1, 1, ..., 1) for modeltype: 4:VRNNrf
%   abase: learning rate base, e.g., 0.1
%   g: time discount factor, e.g., 0.8
%   ndim: dimension, e.g., 12
%   nt: number of trials, e.g., 1500
%
% 1 2 3 4 5 6 7 8 9 10
% C     R     e e e  e
%
%   [os,xs,Vs,ds,wbcos,P] = rnrl101cosones2lra(0.1,0.8,12,1500,[],1);

ITIs = NaN(1,nt);
cue = [];
rew = [];
for k = 1:nt
    tmp = randperm(4);
    ITIs(k) = 2 + tmp(1);
    cue = [cue 1 zeros(1,3+ITIs(k))];
    rew = [rew 0 0 0 1 zeros(1,ITIs(k))];
end
os = [cue; rew]; % observations

if isempty(P)
    P = randn(ndim,ndim+2); % combined A and B
end
w = zeros(1,ndim);
b = 0.5 * ones(1,ndim); % feedback (non-negative)

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
    if t >= 3
        ds(t-1) = rew(t-1) + g*Vs(t) - Vs(t-1);
        wnew = max(0, w + (abase/(ndim/12))*ds(t-1)*xs(:,t-1)');
        y = (xs(:,t-1)<0.5).*xs(:,t-1).*(1-xs(:,t-1)) + (xs(:,t-1)>=0.5)*0.5*0.5;
        P = P + abase*ds(t-1)*(y.*b')*[xs(:,t-2);os(:,t-2)]';
        w = wnew;
    end
end
if plotyn
    figure;
    subplot(3,1,1); hold on; plot(Vs(end-50:end),'k'); plot(ds(end-50:end),'r');
    subplot(3,1,2); hold on; plot(cue(end-50:end),'b'); plot(rew(end-50:end),'g');
    subplot(3,1,3); hold on; plot(acos(wbcos)*(180/pi));
end
