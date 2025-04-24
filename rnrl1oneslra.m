function [os,xs,Vs,ds] = rnrl1oneslra(abase,g,ndim,nt,plotyn)

% rnrl1oneslra: feedback randn*(1, 1, ..., 1) for modeltype: 4:VRNNrf
%   abase: learning rate base, e.g., 0.1
%   g: time discount factor, e.g., 0.8
%   ndim: dimension, e.g., 7
%   nt: number of trials, e.g., 1000
%
% 1 2 3 4 5 6 7 8 9 10
% C     R     e e e  e
%
%   [os,xs,Vs,ds] = rnrl1oneslra(0.1,0.8,7,1000,1);

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

P = randn(ndim,ndim+2); % combined A and B
w = zeros(1,ndim);
b = randn * ones(1,ndim); % feedback

tmax = 4*nt + sum(ITIs);
Vs = NaN(1,tmax);
ds = NaN(1,tmax);
Vs(1) = 0;
xs = NaN(ndim,tmax);
xs(:,1) = randn(ndim,1);
for t = 2:tmax
    xs(:,t) = 1./(1 + exp(-P*[xs(:,t-1);os(:,t-1)])) - 0.5;
    Vs(t) = w * xs(:,t);
    if t >= 3
        ds(t-1) = rew(t-1) + g*Vs(t) - Vs(t-1);
        wnew = w + (abase/(ndim/7))*ds(t-1)*xs(:,t-1)';
        P = P + abase*ds(t-1)*((0.5+xs(:,t-1)).*(0.5-xs(:,t-1)).*b')*[xs(:,t-2);os(:,t-2)]';
        w = wnew;
    end
end
if plotyn
    figure;
    subplot(2,1,1); hold on; plot(Vs(end-50:end),'k'); plot(ds(end-50:end),'r');
    subplot(2,1,2); hold on; plot(cue(end-50:end),'b'); plot(rew(end-50:end),'g');
end
