% for Fig. 2J-left
cd('C:\...\cuerewtask_stat1');
nsim = 100;
load data_tvmakeFig2Jleft_24001
for k1 = 1:3
    msqer{k1} = NaN(nsim,8);
    for k2 = 1:8
        for k3 = 1:nsim
            msqer{k1}(k3,k2) = data.sqer(k1,k2,k3)/4;
        end
    end
    csvwrite(['msqer_' num2str(k1) '.csv'],msqer{k1});
end
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat1")
z1 <- matrix(0, nrow=8, ncol=3)
msqer1 <- read.csv("msqer_1.csv", header=F)
msqer2 <- read.csv("msqer_2.csv", header=F)
msqer3 <- read.csv("msqer_3.csv", header=F)
for(i in 1:8) {
    z1[i,1] <- wilcox.exact(x=msqer1[,i],y=msqer3[,i],paired=F)$p.value
    z1[i,2] <- wilcox.exact(x=msqer2[,i],y=msqer3[,i],paired=F)$p.value
    z1[i,3] <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)$p.value
}
write.csv(z1, "pvalues.csv")
%
pvalues = importdata('pvalues.csv');

% for Fig. 6E-left
cd('C:\...\cuerewtask_stat2');
nsim = 100;
load data_tvmakeFig6Eleft_24011
for k1 = 1:4
    msqer{k1} = NaN(nsim,8);
    for k2 = 1:8
        for k3 = 1:nsim
            msqer{k1}(k3,k2) = data.sqer(k1,k2,k3)/4;
        end
    end
    csvwrite(['msqer_' num2str(k1) '.csv'],msqer{k1});
end
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat2")
z1 <- matrix(0, nrow=8, ncol=5)
msqer1 <- read.csv("msqer_1.csv", header=F)
msqer2 <- read.csv("msqer_2.csv", header=F)
msqer3 <- read.csv("msqer_3.csv", header=F)
msqer4 <- read.csv("msqer_4.csv", header=F)
for(i in 1:8) {
    result1 <- wilcox.exact(x=msqer1[,i],y=msqer3[,i],paired=F)
    result2 <- wilcox.exact(x=msqer1[,i],y=msqer4[,i],paired=F)
    result3 <- wilcox.exact(x=msqer2[,i],y=msqer3[,i],paired=F)
    result4 <- wilcox.exact(x=msqer2[,i],y=msqer4[,i],paired=F)
    result5 <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)
    z1[i,1] <- result1$p.value
    z1[i,2] <- result2$p.value
    z1[i,3] <- result3$p.value
    z1[i,4] <- result4$p.value
    z1[i,5] <- result5$p.value
}
write.csv(z1, "pvalues.csv")
%
pvalues = importdata('pvalues.csv');

% for Fig. 9B
cd('C:\...\cuerewtask_stat3');
nsim = 100;
load data_tvmakeFig9B_25001
for k1 = 1:4
    msqer{k1} = NaN(nsim,8);
    for k2 = 1:8
        for k3 = 1:nsim
            msqer{k1}(k3,k2) = data.sqer(k1,k2,k3)/4;
        end
    end
    csvwrite(['msqer_' num2str(k1) '.csv'],msqer{k1});
end
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat3")
z1 <- matrix(0, nrow=8, ncol=5)
msqer1 <- read.csv("msqer_1.csv", header=F)
msqer2 <- read.csv("msqer_2.csv", header=F)
msqer3 <- read.csv("msqer_3.csv", header=F)
msqer4 <- read.csv("msqer_4.csv", header=F)
for(i in 1:8) {
    z1[i,1] <- wilcox.exact(x=msqer1[,i],y=msqer3[,i],paired=F)$p.value
    z1[i,2] <- wilcox.exact(x=msqer1[,i],y=msqer4[,i],paired=F)$p.value
    z1[i,3] <- wilcox.exact(x=msqer2[,i],y=msqer3[,i],paired=F)$p.value
    z1[i,4] <- wilcox.exact(x=msqer2[,i],y=msqer4[,i],paired=F)$p.value
    z1[i,5] <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)$p.value
}
write.csv(z1, "pvalues.csv")
%
pvalues = importdata('pvalues.csv');

% for Fig. 2M
cd('C:\...\cuerewtask_stat_long1');
load data_tvmakeFig2M_meansqer1_25012
nsim = 100;
CRdur_set = [3:6];
for CRdur = CRdur_set
    for k1 = 1:3
        msqer = NaN(nsim,8);
        for k2 = 1:8
            for k3 = 1:nsim
                msqer(k3,k2) = meansqer1{CRdur}(k1,k2,k3);
            end
        end
        csvwrite(['msqer_' num2str(CRdur) '_' num2str(k1) '.csv'],msqer);
    end
end
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat_long1")
for(j in 3:6) {
    z1 <- matrix(0, nrow=8, ncol=3)
    read_name1 <- paste0("msqer_", as.character(j), "_1.csv")
    read_name2 <- paste0("msqer_", as.character(j), "_2.csv")
    read_name3 <- paste0("msqer_", as.character(j), "_3.csv")
    msqer1 <- read.csv(read_name1, header=F)
    msqer2 <- read.csv(read_name2, header=F)
    msqer3 <- read.csv(read_name3, header=F)
    for(i in 1:8) {
        z1[i,1] <- wilcox.exact(x=msqer1[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,2] <- wilcox.exact(x=msqer2[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,3] <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)$p.value
    }
    write_name <- paste0("pvalues_", as.character(j), ".csv")
    write.csv(z1, write_name)
}
%
for k = 3:6
    pvalues{k} = importdata(['pvalues_' num2str(k) '.csv']);
end

% for Fig. 6J-left
cd('C:\...\cuerewtask_stat_long2');
load data_tvmakeFig6I1_meansqer101_25021
nsim = 100;
CRdur_set = [3:6];
for CRdur = CRdur_set
    for k1 = 1:4
        msqer = NaN(nsim,8);
        for k2 = 1:8
            for k3 = 1:nsim
                msqer(k3,k2) = meansqer101{CRdur}(k1,k2,k3);
            end
        end
        csvwrite(['msqer_' num2str(CRdur) '_' num2str(k1) '.csv'],msqer);
    end
end
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat_long2")
for(j in 3:6) {
    z1 <- matrix(0, nrow=8, ncol=5)
    read_name1 <- paste0("msqer_", as.character(j), "_1.csv")
    read_name2 <- paste0("msqer_", as.character(j), "_2.csv")
    read_name3 <- paste0("msqer_", as.character(j), "_3.csv")
    read_name4 <- paste0("msqer_", as.character(j), "_4.csv")
    msqer1 <- read.csv(read_name1, header=F)
    msqer2 <- read.csv(read_name2, header=F)
    msqer3 <- read.csv(read_name3, header=F)
    msqer4 <- read.csv(read_name4, header=F)
    for(i in 1:8) {
        z1[i,1] <- wilcox.exact(x=msqer1[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,2] <- wilcox.exact(x=msqer1[,i],y=msqer4[,i],paired=F)$p.value
        z1[i,3] <- wilcox.exact(x=msqer2[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,4] <- wilcox.exact(x=msqer2[,i],y=msqer4[,i],paired=F)$p.value
        z1[i,5] <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)$p.value
    }
    write_name <- paste0("pvalues_", as.character(j), ".csv")
    write.csv(z1, write_name)
}
%
for k = 3:6
    pvalues{k} = importdata(['pvalues_' num2str(k) '.csv']);
end

% for Fig. 6J-right
cd('C:\...\cuerewtask_stat_long3');
load data_tvmakeFig6I2_meansqer101_25022
nsim = 100;
CRdur_set = [3:6];
for CRdur = CRdur_set
    for k1 = 1:4
        msqer = NaN(nsim,8);
        for k2 = 1:8
            for k3 = 1:nsim
                msqer(k3,k2) = meansqer101{CRdur}(k1,k2,k3);
            end
        end
        csvwrite(['msqer_' num2str(CRdur) '_' num2str(k1) '.csv'],msqer);
    end
end
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat_long3")
for(j in 3:6) {
    z1 <- matrix(0, nrow=8, ncol=5)
    read_name1 <- paste0("msqer_", as.character(j), "_1.csv")
    read_name2 <- paste0("msqer_", as.character(j), "_2.csv")
    read_name3 <- paste0("msqer_", as.character(j), "_3.csv")
    read_name4 <- paste0("msqer_", as.character(j), "_4.csv")
    msqer1 <- read.csv(read_name1, header=F)
    msqer2 <- read.csv(read_name2, header=F)
    msqer3 <- read.csv(read_name3, header=F)
    msqer4 <- read.csv(read_name4, header=F)
    for(i in 1:8) {
        z1[i,1] <- wilcox.exact(x=msqer1[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,2] <- wilcox.exact(x=msqer1[,i],y=msqer4[,i],paired=F)$p.value
        z1[i,3] <- wilcox.exact(x=msqer2[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,4] <- wilcox.exact(x=msqer2[,i],y=msqer4[,i],paired=F)$p.value
        z1[i,5] <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)$p.value
    }
    write_name <- paste0("pvalues_", as.character(j), ".csv")
    write.csv(z1, write_name)
}
%
for k = 3:6
    pvalues{k} = importdata(['pvalues_' num2str(k) '.csv']);
end

% for Fig. 10-middle
cd('C:\...\cuerewtask_stat_dist');
load data_tvmakeFig10_25003
nsim = 100;
for k0 = 1:4
    for k1 = 1:4
        msqer = NaN(nsim,8);
        for k2 = 1:8
            for k3 = 1:nsim
                msqer(k3,k2) = data{k0}.sqer(k1,k2,k3)/4;
            end
        end
        csvwrite(['msqer_' num2str(k0) '_' num2str(k1) '.csv'],msqer);
    end
end
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat_dist")
for(j in 1:4) {
    z1 <- matrix(0, nrow=8, ncol=5)
    read_name1 <- paste0("msqer_", as.character(j), "_1.csv")
    read_name2 <- paste0("msqer_", as.character(j), "_2.csv")
    read_name3 <- paste0("msqer_", as.character(j), "_3.csv")
    read_name4 <- paste0("msqer_", as.character(j), "_4.csv")
    msqer1 <- read.csv(read_name1, header=F)
    msqer2 <- read.csv(read_name2, header=F)
    msqer3 <- read.csv(read_name3, header=F)
    msqer4 <- read.csv(read_name4, header=F)
    for(i in 1:8) {
        z1[i,1] <- wilcox.exact(x=msqer1[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,2] <- wilcox.exact(x=msqer1[,i],y=msqer4[,i],paired=F)$p.value
        z1[i,3] <- wilcox.exact(x=msqer2[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,4] <- wilcox.exact(x=msqer2[,i],y=msqer4[,i],paired=F)$p.value
        z1[i,5] <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)$p.value
    }
    write_name <- paste0("pvalues_", as.character(j), ".csv")
    write.csv(z1, write_name)
}
%
for k = 1:4
    pvalues{k} = importdata(['pvalues_' num2str(k) '.csv']);
end

% for Fig. 10-right
cd('C:\...\cuerewtask_stat_dist_ei');
load data_tvmakeFig10ei_25103
nsim = 100;
for k0 = 1:4
    for k1 = 1:4
        msqer = NaN(nsim,8);
        for k2 = 1:8
            for k3 = 1:nsim
                msqer(k3,k2) = data{k0}.sqer(k1,k2,k3)/4;
            end
        end
        csvwrite(['msqer_' num2str(k0) '_' num2str(k1) '.csv'],msqer);
    end
end
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat_dist_ei")
for(j in 1:4) {
    z1 <- matrix(0, nrow=8, ncol=5)
    read_name1 <- paste0("msqer_", as.character(j), "_1.csv")
    read_name2 <- paste0("msqer_", as.character(j), "_2.csv")
    read_name3 <- paste0("msqer_", as.character(j), "_3.csv")
    read_name4 <- paste0("msqer_", as.character(j), "_4.csv")
    msqer1 <- read.csv(read_name1, header=F)
    msqer2 <- read.csv(read_name2, header=F)
    msqer3 <- read.csv(read_name3, header=F)
    msqer4 <- read.csv(read_name4, header=F)
    for(i in 1:8) {
        z1[i,1] <- wilcox.exact(x=msqer1[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,2] <- wilcox.exact(x=msqer1[,i],y=msqer4[,i],paired=F)$p.value
        z1[i,3] <- wilcox.exact(x=msqer2[,i],y=msqer3[,i],paired=F)$p.value
        z1[i,4] <- wilcox.exact(x=msqer2[,i],y=msqer4[,i],paired=F)$p.value
        z1[i,5] <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)$p.value
    }
    write_name <- paste0("pvalues_", as.character(j), ".csv")
    write.csv(z1, write_name)
}
%
for k = 1:4
    pvalues{k} = importdata(['pvalues_' num2str(k) '.csv']);
end

% compare Fig. 2J-left and Fig. 6E-left
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat1")
msqerVRNNbp <- read.csv("msqer_1.csv", header=F)
msqerVRNNrf <- read.csv("msqer_2.csv", header=F)
setwd("C:/.../cuerewtask_stat2")
msqerbioVRNNrf <- read.csv("msqer_2.csv", header=F)
z1 <- matrix(0, nrow=8, ncol=2)
for(i in 1:8) {
    z1[i,1] <- wilcox.exact(x=msqerbioVRNNrf[,i],y=msqerVRNNbp[,i],paired=F)$p.value
    z1[i,2] <- wilcox.exact(x=msqerbioVRNNrf[,i],y=msqerVRNNrf[,i],paired=F)$p.value
}
write.csv(z1, "compare2Jleft6Eleft_pvalues.csv")

% for Fig. 6I
cd('C:\...\cuerewtask_stat4');
load data_tvmakeFig6H_26002
nsim = 100;
for k1 = 1:4
    msqer{k1} = NaN(nsim,30);
    for k2 = 1:30
        for k3 = 1:nsim
            msqer{k1}(k3,k2) = data.sqer(k1,k2,k3);
        end
    end
    csvwrite(['msqer_' num2str(k1) '.csv'],msqer{k1});
end
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat4")
msqer1 <- read.csv("msqer_1.csv", header=F)
msqer2 <- read.csv("msqer_2.csv", header=F)
z1 <- matrix(0, nrow=30, ncol=1)
for(i in 1:30) {
    z1[i,1] <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)$p.value
}
write.csv(z1, "pvalues.csv")

% compare Fig. 2M and Fig. 6J-left
cd('C:\...\cuerewtask_stat_long1');
load data_tvmakeFig2M_meansqer1_25012
nsim = 100;
CRdur_set = 6; %[3:6];
for CRdur = CRdur_set
    for k1 = 2 %1:3
        msqer = NaN(nsim,8);
        for k2 = 1:8
            for k3 = 1:nsim
                msqer(k3,k2) = meansqer1{CRdur}(k1,k2,k3);
            end
        end
        %csvwrite(['msqer_' num2str(CRdur) '_' num2str(k1) '.csv'],msqer);
    end
end
msqer1 = msqer; clear msqer
cd('C:\...\cuerewtask_stat_long2');
load data_tvmakeFig6I1_meansqer101_25021
nsim = 100;
CRdur_set = 6; %[3:6];
for CRdur = CRdur_set
    for k1 = 2 %1:4
        msqer = NaN(nsim,8);
        for k2 = 1:8
            for k3 = 1:nsim
                msqer(k3,k2) = meansqer101{CRdur}(k1,k2,k3);
            end
        end
        %csvwrite(['msqer_' num2str(CRdur) '_' num2str(k1) '.csv'],msqer);
    end
end
msqer2 = msqer; clear msqer
% in R
library(exactRankTests)
setwd("C:/.../cuerewtask_stat_long1")
msqer1 <- read.csv("msqer_6_2.csv", header=F)
setwd("C:/.../cuerewtask_stat_long2")
msqer2 <- read.csv("msqer_6_2.csv", header=F)
setwd("C:/.../cuerewtask_stat_long4")
z1 <- matrix(0, nrow=8, ncol=1)
for(i in 1:8) {
    z1[i] <- wilcox.exact(x=msqer1[,i],y=msqer2[,i],paired=F)$p.value
}
write.csv(z1, "pvalues.csv")
