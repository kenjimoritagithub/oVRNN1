function [os,xs,xis,Vs,ds,wbcos,P] = rnrl101coseilra(modeltype,abase,g,ndim,nt,P,plotyn)

% rnrl101coseilra : RNN with excitatory and inhibitory units
%   modeltype: 3:RevVRNNbp, 4:BioVRNNrf, 5:untrained RNN
%   abase: learning rate base, e.g., 0.1
%   g: time discount factor, e.g., 0.8
%   ndim: dimension, e.g., 12
%   nt: number of trials, e.g., 1500
%
% 1 2 3 4 5 6 7 8 9 10
% C     R     e e e  e
%
%   [os,xs,xis,Vs,ds,wbcos,P] = rnrl101coseilra(4,0.1,0.8,12,1500,[],1);

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
    P.e = max(0, 3 + randn(ndim,ndim+2));
    P.i = max(0, 3 + randn(ndim,ndim+2));
end
w = zeros(1,ndim);
b = rand(1,ndim); % random feedback (non-negative)

tmax = 4*nt + sum(ITIs);
Vs = NaN(1,tmax);
ds = NaN(1,tmax);
Vs(1) = 0;
xs = NaN(ndim,tmax);
xs(:,1) = rand(ndim,1);
xis = NaN(ndim,tmax);
wbcos = NaN(1,tmax);
for t = 2:tmax
    wbcos(t) = sum(w.*b)/(sqrt(sum(w.*w))*sqrt(sum(b.*b)));
    xis(:,t) = P.i*[xs(:,t-1);os(:,t-1)];
    xs(:,t) = 1./(1 + exp(-(P.e*[xs(:,t-1);os(:,t-1)] - xis(:,t))));
    Vs(t) = w * xs(:,t);
    if t >= 3
        ds(t-1) = rew(t-1) + g*Vs(t) - Vs(t-1);
        wnew = max(0, w + (abase/(ndim/12))*ds(t-1)*xs(:,t-1)');
        if modeltype == 3
            P.e = P.e + abase*ds(t-1)*(xs(:,t-1).*(1-xs(:,t-1)).*w')*[xs(:,t-2);os(:,t-2)]';
            P.e = max(0, P.e);
        elseif modeltype == 4
            %P.e = P.e + abase*ds(t-1)*(xs(:,t-1).*(1-xs(:,t-1)).*b')*[xs(:,t-2);os(:,t-2)]';
            y = (xs(:,t-1)<0.5).*xs(:,t-1).*(1-xs(:,t-1)) + (xs(:,t-1)>=0.5)*0.5*0.5;
            P.e = P.e + abase*ds(t-1)*(y.*b')*[xs(:,t-2);os(:,t-2)]';
            P.e = max(0, P.e);
        end
        w = wnew;
    end
end
if plotyn
    figure;
    subplot(3,1,1); hold on; plot(Vs(end-50:end),'k'); plot(ds(end-50:end),'r');
    subplot(3,1,2); hold on; plot(cue(end-50:end),'b'); plot(rew(end-50:end),'g');
    subplot(3,1,3); hold on; plot(acos(wbcos)*(180/pi));
end
