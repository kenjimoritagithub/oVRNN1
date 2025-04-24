%
clear all
simseed = setrandoms(24060301);

%
ndim = 7;
nsim = 100;
for modeltype = 1:5
    data2.wbangle_set{modeltype} = NaN(nsim,1000);
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype,ksim);
        [os,xs,Vs,ds,wbcos] = rnrl1cos(modeltype,0.1,0.8,ndim,1000,0);
        if (modeltype == 3) || (modeltype == 4)
            tmp_cue = find(os(1,:));
            data2.wbangle_set{modeltype}(ksim,:) = acos(wbcos(tmp_cue))*(180/pi);
        end
    end
end
save(['data2' num2str(simseed)],'data2');

%
modeltype = 4;
F = figure;
A = axes;
hold on;
axis([0 1000 -10 190]);
P = plot([0 1000],[0 0],'k:');
P = plot([0 1000],[180 180],'k:');
P = plot([0 1000],[90 90],'k');
P = plot([0 1000],[45 45],'k-.');
P = plot([1:1000],mean(data2.wbangle_set{modeltype},1)+std(data2.wbangle_set{modeltype},0,1),'r--'); % SD (rather than SEM)
P = plot([1:1000],mean(data2.wbangle_set{modeltype},1)-std(data2.wbangle_set{modeltype},0,1),'r--'); % SD (rather than SEM)
P = plot([1:1000],mean(data2.wbangle_set{modeltype},1),'r');
set(A,'XTick',[0:200:1000],'XTickLabel',[0:200:1000],'YTick',[0:45:180],'YTickLabel',[0:45:180],'FontSize',40);
print(F,'-depsc','Fig3A');

%
clear all
simseed = 24060301;
nsim = 100;
modeltype = 4;
load data24060301
load data224060301
[r,p] = corrcoef(data2.wbangle_set{4}(:,end),data.Vs_set{4}(:,5)); % r(1,2):-0.2883, p(1,2):0.003623
csvwrite(['V_wbangle_' num2str(simseed) '.csv'],[data.Vs_set{4}(:,5) data2.wbangle_set{4}(:,end)]);
% (in R)
setwd("working_directory")
V_wbangle <- read.csv("V_wbangle_24060301.csv", header=F)
model <- lm(V1 ~ 1 + V2, data = V_wbangle)
sumodel <- summary(model)
coef <- sumodel$coefficients
R2 <- sumodel$r.squared
write.csv(coef,"V_wbangle_24060301_coef.csv")
write.csv(R2,"V_wbangle_24060301_R2.csv")
%
V_wbangle_coef = importdata('V_wbangle_24060301_coef.csv'); % V_wbangle_coef.data(2,4):0.003623
V_wbangle_R2 = importdata('V_wbangle_24060301_R2.csv'); %V_wbangle_R2.data:0.08314 (~(-0.2883)^2)
%
F = figure;
A = axes;
hold on;
if (max(data2.wbangle_set{4}(:,end))>120) || (max(data.Vs_set{4}(:,5))>1.2) || (min(data.Vs_set{4}(:,5))<-0.2)
    error('range should be changed');
end
axis([0 120 -0.2 1.2]);
P = plot([0 120],V_wbangle_coef.data(1,1) + V_wbangle_coef.data(2,1)*[0 120],'r');
P = plot(data2.wbangle_set{4}(:,end),data.Vs_set{4}(:,5),'k.'); set(P,'MarkerSize',20);
set(A,'XTick',[0:45:90],'XTickLabel',[0:45:90],'YTick',[-0.2:0.2:1.2],'YTickLabel',[-0.2:0.2:1.2],'FontSize',40);
print(F,'-depsc','Fig3B');
