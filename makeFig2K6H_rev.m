%
cd('C:\...\pca1');
clear all
simseed = setrandoms(24001);
%
ndim_set = [5:5:40];
nsim = 100;
for k1 = 1:4 %length(ndim_set)
    ndim = ndim_set(k1);
    for modeltype = 3:5
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,Vs,ds] = rnrl1lra(modeltype,0.1,0.8,ndim,1000,0);
            if k1 == 4
                csvwrite(['xs1_' num2str(modeltype) '_' num2str(ksim) '.csv'],xs');
            end
        end
    end
end
% in R
setwd("C:/.../pca1")
z1 <- matrix(0, nrow=300, ncol=20)
for(i in 3:5) {
    for(j in 1:100) {
        s1 <- as.character(i)
        s2 <- as.character(j)
        read_name <- paste0("xs1_", s1, "_", s2, ".csv")
        data <-read.csv(read_name, header=F)
        result <- prcomp(data, scale=T)
        z1[100*(i-3)+j,] <- result$sdev^2/sum(result$sdev^2)
    }
}
write.csv(z1, "xs_set1_contriratio_24001.csv")
%
cr1 = importdata('xs_set1_contriratio_24001.csv');
%
logdata = log(cr1.data);
nsim = 100;
maxdim = 20; % 8
F = figure;
A = axes;
hold on;
axis([0 21 -9 -1]);
P = plot([1:maxdim],mean(logdata(1:100,1:maxdim),1)-std(logdata(1:100,1:maxdim),0,1)/sqrt(nsim),'r--');
P = plot([1:maxdim],mean(logdata(1:100,1:maxdim),1)+std(logdata(1:100,1:maxdim),0,1)/sqrt(nsim),'r--');
P = plot([1:maxdim],mean(logdata(101:200,1:maxdim),1)-std(logdata(101:200,1:maxdim),0,1)/sqrt(nsim),'b--');
P = plot([1:maxdim],mean(logdata(101:200,1:maxdim),1)+std(logdata(101:200,1:maxdim),0,1)/sqrt(nsim),'b--');
P = plot([1:maxdim],mean(logdata(201:300,1:maxdim),1)-std(logdata(201:300,1:maxdim),0,1)/sqrt(nsim),'y--'); set(P,'Color',0.5*[1 1 1]);
P = plot([1:maxdim],mean(logdata(201:300,1:maxdim),1)+std(logdata(201:300,1:maxdim),0,1)/sqrt(nsim),'y--'); set(P,'Color',0.5*[1 1 1]);
P = plot([1:maxdim],mean(logdata(1:100,1:maxdim),1),'r');
P = plot([1:maxdim],mean(logdata(101:200,1:maxdim),1),'b');
P = plot([1:maxdim],mean(logdata(201:300,1:maxdim),1),'y'); set(P,'Color',0.5*[1 1 1]);
%set(A,'PlotBoxAspectRatio',[4 1 1]);
set(A,'XTick',[1:20],'YTick',[-9:-1],'XTickLabel',[],'YTickLabel',[]);
print(F,'-depsc','Fig2K');


%
cd('C:\...\pca101');
clear all
simseed = setrandoms(24011);
%
ndim_set = [5:5:40];
nsim = 100;
for k1 = 1:4 %length(ndim_set)
    ndim = ndim_set(k1);
    P_set = NaN(ndim,ndim+2,nsim);
    for modeltype = 3:5
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype,ksim);
            [os,xs,Vs,ds,wbcos,P] = rnrl101coslra(modeltype,0.1,0.8,ndim,1500,[],0);
            if k1 == 4
                csvwrite(['xs101_' num2str(modeltype) '_' num2str(ksim) '.csv'],xs');
            end
            if modeltype == 4
                P_set(:,:,ksim) = P;
            end
        end
    end
    for modeltype = 5
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',k1,modeltype+1,ksim);
            tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+2),1);
            tmp_P = tmp_P(randperm(ndim*(ndim+2)));
            P = reshape(tmp_P,ndim,ndim+2);
            [os,xs,Vs,ds,wbcos,P] = rnrl101coslra(modeltype,0.1,0.8,ndim,1500,P,0);
            if k1 == 4
                csvwrite(['xs101_' num2str(modeltype+1) '_' num2str(ksim) '.csv'],xs');
            end
        end
    end
end
% in R
setwd("C:/.../pca101")
z101 <- matrix(0, nrow=400, ncol=20)
for(i in 3:6) {
    for(j in 1:100) {
        s1 <- as.character(i)
        s2 <- as.character(j)
        read_name <- paste0("xs101_", s1, "_", s2, ".csv")
        data <-read.csv(read_name, header=F)
        result <- prcomp(data, scale=T)
        z101[100*(i-3)+j,] <- result$sdev^2/sum(result$sdev^2)
    }
}
write.csv(z101, "xs_set101_contriratio_24011.csv")
%
cr101 = importdata('xs_set101_contriratio_24011.csv');
%
logdata = log(cr101.data);
nsim = 100;
maxdim = 20; % 8
F = figure;
A = axes;
hold on;
axis([0 21 -14 0]);
P = plot([1:maxdim],mean(logdata(1:100,1:maxdim),1)-std(logdata(1:100,1:maxdim),0,1)/sqrt(nsim),'r--');
P = plot([1:maxdim],mean(logdata(1:100,1:maxdim),1)+std(logdata(1:100,1:maxdim),0,1)/sqrt(nsim),'r--');
P = plot([1:maxdim],mean(logdata(101:200,1:maxdim),1)-std(logdata(101:200,1:maxdim),0,1)/sqrt(nsim),'b--');
P = plot([1:maxdim],mean(logdata(101:200,1:maxdim),1)+std(logdata(101:200,1:maxdim),0,1)/sqrt(nsim),'b--');
P = plot([1:maxdim],mean(logdata(201:300,1:maxdim),1)-std(logdata(201:300,1:maxdim),0,1)/sqrt(nsim),'y--'); set(P,'Color',0.5*[1 1 1]);
P = plot([1:maxdim],mean(logdata(201:300,1:maxdim),1)+std(logdata(201:300,1:maxdim),0,1)/sqrt(nsim),'y--'); set(P,'Color',0.5*[1 1 1]);
P = plot([1:maxdim],mean(logdata(301:400,1:maxdim),1)-std(logdata(301:400,1:maxdim),0,1)/sqrt(nsim),'m--'); set(P,'Color',0.5*[1 1 1]);
P = plot([1:maxdim],mean(logdata(301:400,1:maxdim),1)+std(logdata(301:400,1:maxdim),0,1)/sqrt(nsim),'m--'); set(P,'Color',0.5*[1 1 1]);
P = plot([1:maxdim],mean(logdata(1:100,1:maxdim),1),'r');
P = plot([1:maxdim],mean(logdata(101:200,1:maxdim),1),'b');
P = plot([1:maxdim],mean(logdata(201:300,1:maxdim),1),'y'); set(P,'Color',0.5*[1 1 1]);
P = plot([1:maxdim],mean(logdata(301:400,1:maxdim),1),'m'); set(P,'Color',0.5*[1 1 1]); set(P,'LineStyle','--');
%set(A,'PlotBoxAspectRatio',[4 1 1]);
set(A,'XTick',[1:20],'YTick',[-14:2:0],'XTickLabel',[],'YTickLabel',[]);
print(F,'-depsc','Fig6H');
