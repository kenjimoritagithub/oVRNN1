%
cd('C:\...\pca1');
cr1 = importdata('xs_set1_contriratio_24001.csv');
logdata = log(cr1.data);
logd1 = logdata(1:100,:);
logd2 = logdata(101:200,:);
logd3 = logdata(201:300,:);
cd('C:\...\pca1\wilcox');
csvwrite('logd1.csv',logd1);
csvwrite('logd2.csv',logd2);
csvwrite('logd3.csv',logd3);
% in R
library(exactRankTests)
setwd("C:/.../pca1/wilcox")
z1 <- matrix(0, nrow=20, ncol=3)
logd1 <- read.csv("logd1.csv", header=F)
logd2 <- read.csv("logd2.csv", header=F)
logd3 <- read.csv("logd3.csv", header=F)
for(i in 1:20) {
    z1[i,1] <- wilcox.exact(x=logd1[,i],y=logd3[,i],paired=F)$p.value
    z1[i,2] <- wilcox.exact(x=logd2[,i],y=logd3[,i],paired=F)$p.value
    z1[i,3] <- wilcox.exact(x=logd1[,i],y=logd2[,i],paired=F)$p.value
}
write.csv(z1, "pvalues.csv")
z2 <- matrix(0, nrow=20, ncol=3)
for(i in 1:20) {
    z2[i,1] <- t.test(x=logd1[,i],y=logd3[,i],paired=F)$p.value
    z2[i,2] <- t.test(x=logd2[,i],y=logd3[,i],paired=F)$p.value
    z2[i,3] <- t.test(x=logd1[,i],y=logd2[,i],paired=F)$p.value
}
write.csv(z2, "ttest_pvalues.csv")
%
pvalues = importdata('pvalues.csv');
ttest_pvalues = importdata('ttest_pvalues.csv');

%
cd('C:\...\pca101');
cr101 = importdata('xs_set101_contriratio_24011.csv');
logdata = log(cr101.data);
logd1 = logdata(1:100,:);
logd2 = logdata(101:200,:);
logd3 = logdata(201:300,:);
logd4 = logdata(301:400,:);
cd('C:\...\pca101\wilcox');
csvwrite('logd1.csv',logd1);
csvwrite('logd2.csv',logd2);
csvwrite('logd3.csv',logd3);
csvwrite('logd4.csv',logd4);
% in R
library(exactRankTests)
setwd("C:/.../pca101/wilcox")
z1 <- matrix(0, nrow=20, ncol=5)
logd1 <- read.csv("logd1.csv", header=F)
logd2 <- read.csv("logd2.csv", header=F)
logd3 <- read.csv("logd3.csv", header=F)
logd4 <- read.csv("logd4.csv", header=F)
for(i in 1:20) {
    z1[i,1] <- wilcox.exact(x=logd1[,i],y=logd3[,i],paired=F)$p.value
    z1[i,2] <- wilcox.exact(x=logd1[,i],y=logd4[,i],paired=F)$p.value
    z1[i,3] <- wilcox.exact(x=logd2[,i],y=logd3[,i],paired=F)$p.value
    z1[i,4] <- wilcox.exact(x=logd2[,i],y=logd4[,i],paired=F)$p.value
    z1[i,5] <- wilcox.exact(x=logd1[,i],y=logd2[,i],paired=F)$p.value
}
write.csv(z1, "pvalues.csv")
z2 <- matrix(0, nrow=20, ncol=5)
for(i in 1:20) {
    z2[i,1] <- t.test(x=logd1[,i],y=logd3[,i],paired=F)$p.value
    z2[i,2] <- t.test(x=logd1[,i],y=logd4[,i],paired=F)$p.value
    z2[i,3] <- t.test(x=logd2[,i],y=logd3[,i],paired=F)$p.value
    z2[i,4] <- t.test(x=logd2[,i],y=logd4[,i],paired=F)$p.value
    z2[i,5] <- t.test(x=logd1[,i],y=logd2[,i],paired=F)$p.value
}
write.csv(z2, "ttest_pvalues.csv")
%
pvalues = importdata('pvalues.csv');
ttest_pvalues = importdata('ttest_pvalues.csv');
