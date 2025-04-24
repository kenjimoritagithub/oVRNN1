function out = rnrl1lra_every100(modeltype,abase,g,ndim,nt,plotyn)

% rnrl1lra_every100
%   modeltype: 1:punctate(w/o continuation), 2:punctate, 3:VRNNbp, 4:VRNNrf, 5:untrained RNN
%   abase: learning rate base, e.g., 0.1
%   g: time discount factor, e.g., 0.8
%   ndim: dimension, e.g., 7
%   nt: number of trials, e.g., 1000
%
% 1 2 3 4 5 6 7 8 9 10
% C     R     e e e  e
%
%   out = rnrl1lra_every100(4,0.1,0.8,7,1000,1);

if (modeltype == 1) || (modeltype == 2)
    ndim = 10;
end

ITIs = NaN(1,nt);
cue = [];
rew = [];
states = [];
stateM = eye(10);
for k = 1:nt
    tmp = randperm(4);
    ITIs(k) = 2 + tmp(1);
    cue = [cue 1 zeros(1,3+ITIs(k))];
    rew = [rew 0 0 0 1 zeros(1,ITIs(k))];
    states = [states stateM(:,1:4+ITIs(k))];
end
os = [cue; rew]; % observations

P = randn(ndim,ndim+2); % combined A and B
w = zeros(1,ndim);
b = randn(1,ndim); % random feedback

tmax = 4*nt + sum(ITIs);
%
t_cue = find(cue);
t_save = [t_cue([101:100:(floor(nt/100)-1)*100+1])-1 tmax];
%
Vs = NaN(1,tmax);
ds = NaN(1,tmax);
Vs(1) = 0;
xs = NaN(ndim,tmax);
xs(:,1) = randn(ndim,1);
if (modeltype == 1) || (modeltype == 2)
    xs = [stateM(:,end) states(:,1:end-1)];
end
for t = 2:tmax
    if (modeltype == 3) || (modeltype == 4) || (modeltype == 5)
        xs(:,t) = 1./(1 + exp(-P*[xs(:,t-1);os(:,t-1)])) - 0.5;
    end
    Vs(t) = w * xs(:,t);
    if t >= 3
        ds(t-1) = rew(t-1) + g*Vs(t) - Vs(t-1);
        if ((modeltype == 1) && (xs(1,t) == 1))
            wnew = w;
        else
            wnew = w + (abase/(ndim/7))*ds(t-1)*xs(:,t-1)';
        end
        if modeltype == 3
            P = P + abase*ds(t-1)*((0.5+xs(:,t-1)).*(0.5-xs(:,t-1)).*w')*[xs(:,t-2);os(:,t-2)]';
        elseif modeltype == 4
            P = P + abase*ds(t-1)*((0.5+xs(:,t-1)).*(0.5-xs(:,t-1)).*b')*[xs(:,t-2);os(:,t-2)]';
        end
        w = wnew;
    end
    if sum(t == t_save)
        out{t==t_save}.os = os(:,1:t);
        out{t==t_save}.xs = xs(:,1:t);
        out{t==t_save}.Vs = Vs(1:t);
        out{t==t_save}.ds = ds(1:t);
    end
end
if plotyn
    figure;
    subplot(2,1,1); hold on; plot(Vs(end-50:end),'k'); plot(ds(end-50:end),'r');
    subplot(2,1,2); hold on; plot(cue(end-50:end),'b'); plot(rew(end-50:end),'g');
end
