%
clear all
simseed = setrandoms(24060301);

%
ndim = 7;
nsim = 100;
for modeltype = 1:4
    for ksim = 1:nsim
        fprintf('%d-%d\n',modeltype,ksim);
        [os,xs,Vs,ds] = rnrl1(modeltype,0.1,0.8,ndim,1000,0);
        if ksim == 4
            break;
        end
    end
end

%
csvwrite(['xs_' num2str(simseed) '.csv'],xs');
% in R
setwd("working_directory")
data <-read.csv("xs_24060301.csv", header=F)
result <- prcomp(data, scale=T)
score <- result$x
write.csv(score, "xspca_24060301.csv")
%
xspca = importdata('xspca_24060301.csv');
t_cue = find(os(1,:));

%
tri_plot_set = [10 11 12; 300 301 302; 600 601 602; 900 901 902];
tmp_col = 'rbg';
%
for k1 = 1:4
    Vs_plot = Vs(t_cue(tri_plot_set(k1,2))-2:t_cue(tri_plot_set(k1,2))+5);
    ds_plot = ds(t_cue(tri_plot_set(k1,2))-2:t_cue(tri_plot_set(k1,2))+5);
    F = figure;
    A = axes;
    hold on;
    axis([-2 5 -0.5 1.5]);
    P = plot([-2 5],[0 0],'k:');
    P = plot([-2:5],Vs_plot,'k');
    P = plot([-2:5],ds_plot,'r');
    set(A,'XTick',[-2:5],'XTickLabel',[-2:5],'YTick',[-0.5:0.5:1.5],'YTickLabel',[-0.5:0.5:1.5],'FontSize',40);
    print(F,'-depsc',['Fig3E-R' num2str(k1)]);
end
%
for k1 = 1:4
    tri_plot = tri_plot_set(k1,:);
    F = figure;
    A = axes;
    hold on
    axis([-5 5 -5 5]);
    P = plot([-5 5],[0 0],'k:');
    P = plot([0 0],[-5 5],'k:');
    for k2 = 1:3
        P = plot(xspca.data(t_cue(tri_plot(k2))+1,1),xspca.data(t_cue(tri_plot(k2))+1,2),[tmp_col(k2) 'x']); set(P,'MarkerSize',20);
        P = plot(xspca.data(t_cue(tri_plot(k2))+4,1),xspca.data(t_cue(tri_plot(k2))+4,2),[tmp_col(k2) 'o']); set(P,'MarkerSize',20);
        P = plot(xspca.data(t_cue(tri_plot(k2)):t_cue(tri_plot(k2)+1)-1,1),xspca.data(t_cue(tri_plot(k2)):t_cue(tri_plot(k2)+1)-1,2),tmp_col(k2));
    end
    set(A,'PlotBoxAspectRatio',[1 1 1]);
    set(A,'XTick',[-5:5],'XTickLabel',[-5:5],'YTick',[-5:5],'YTickLabel',[-5:5]);
    set(A,'FontSize',40);
    print(F,'-depsc',['Fig3E-L' num2str(k1)]);
end
