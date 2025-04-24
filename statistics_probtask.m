% for Fig. 4
cd('C:\...\probtask_ttest1');
load data_lrmakeFig4DtoH_25010
for modeltype = 1:5
    csvwrite(['TDRPE_task1_R1_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{1}{1}(:,5));
    csvwrite(['TDRPE_task1_R2_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{1}{2}(:,7));
    csvwrite(['TDRPE_task2_R1_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{2}{1}(:,5));
    csvwrite(['TDRPE_task2_R2_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{2}{2}(:,7));
end
dvalues = NaN(5,2);
for modeltype = 1:5
    x = data.ds_set{modeltype}{1}{1}(:,5);
    y = data.ds_set{modeltype}{1}{2}(:,7);
    dvalues(modeltype,1) = (mean(x) - mean(y))/sqrt((std(x)^2 + std(y)^2)/2);
    x = data.ds_set{modeltype}{2}{1}(:,5);
    y = data.ds_set{modeltype}{2}{2}(:,7);
    dvalues(modeltype,2) = (mean(y) - mean(x))/sqrt((std(x)^2 + std(y)^2)/2);
end
save dvalues dvalues
% in R (option: % alternative="greater" for result1, alternative="less" for result2)
setwd("C:/.../probtask_ttest1")
z1 <- matrix(0, nrow=5, ncol=2)
for(i in 1:5) {
    s <- as.character(i)
    read_name1 <- paste0("TDRPE_task1_R1_", s, ".csv")
    read_name2 <- paste0("TDRPE_task1_R2_", s, ".csv")
    read_name3 <- paste0("TDRPE_task2_R1_", s, ".csv")
    read_name4 <- paste0("TDRPE_task2_R2_", s, ".csv")
    data1 <-read.csv(read_name1, header=F)
    data2 <-read.csv(read_name2, header=F)
    data3 <-read.csv(read_name3, header=F)
    data4 <-read.csv(read_name4, header=F)
    result1 <- t.test(x=data1$V1,y=data2$V1,paired=T)
    result2 <- t.test(x=data3$V1,y=data4$V1,paired=T)
    z1[i,1] <- result1$p.value
    z1[i,2] <- result2$p.value
}
write.csv(z1, "pvalues.csv")
%
pvalues = importdata('pvalues.csv');

% for Fig. 7
cd('C:\...\probtask_ttest2');
load data_lrmakeFig8_25000
for modeltype = 3:6
    csvwrite(['TDRPE_task1_R1_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{1}{1}(:,5));
    csvwrite(['TDRPE_task1_R2_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{1}{2}(:,7));
    csvwrite(['TDRPE_task2_R1_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{2}{1}(:,5));
    csvwrite(['TDRPE_task2_R2_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{2}{2}(:,7));
end
dvalues = NaN(4,2);
for modeltype = 3:6
    x = data.ds_set{modeltype}{1}{1}(:,5);
    y = data.ds_set{modeltype}{1}{2}(:,7);
    dvalues(modeltype-2,1) = (mean(x) - mean(y))/sqrt((std(x)^2 + std(y)^2)/2);
    x = data.ds_set{modeltype}{2}{1}(:,5);
    y = data.ds_set{modeltype}{2}{2}(:,7);
    dvalues(modeltype-2,2) = (mean(y) - mean(x))/sqrt((std(x)^2 + std(y)^2)/2);
end
save dvalues dvalues
% in R (option: % alternative="greater" for result1, alternative="less" for result2)
setwd("C:/.../probtask_ttest2")
z1 <- matrix(0, nrow=4, ncol=2)
for(i in 3:6) {
    s <- as.character(i)
    read_name1 <- paste0("TDRPE_task1_R1_", s, ".csv")
    read_name2 <- paste0("TDRPE_task1_R2_", s, ".csv")
    read_name3 <- paste0("TDRPE_task2_R1_", s, ".csv")
    read_name4 <- paste0("TDRPE_task2_R2_", s, ".csv")
    data1 <-read.csv(read_name1, header=F)
    data2 <-read.csv(read_name2, header=F)
    data3 <-read.csv(read_name3, header=F)
    data4 <-read.csv(read_name4, header=F)
    result1 <- t.test(x=data1$V1,y=data2$V1,paired=T)
    result2 <- t.test(x=data3$V1,y=data4$V1,paired=T)
    z1[i-2,1] <- result1$p.value
    z1[i-2,2] <- result2$p.value
}
write.csv(z1, "pvalues.csv")
%
pvalues = importdata('pvalues.csv');

% for Fig. 9C
cd('C:\...\probtask_ttest3');
load data_lrmakeFig9C_25002
for modeltype = 3:6
    csvwrite(['TDRPE_task1_R1_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{1}{1}(:,5));
    csvwrite(['TDRPE_task1_R2_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{1}{2}(:,7));
    csvwrite(['TDRPE_task2_R1_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{2}{1}(:,5));
    csvwrite(['TDRPE_task2_R2_' num2str(modeltype) '.csv'],data.ds_set{modeltype}{2}{2}(:,7));
end
dvalues = NaN(4,2);
for modeltype = 3:6
    x = data.ds_set{modeltype}{1}{1}(:,5);
    y = data.ds_set{modeltype}{1}{2}(:,7);
    dvalues(modeltype-2,1) = (mean(x) - mean(y))/sqrt((std(x)^2 + std(y)^2)/2);
    x = data.ds_set{modeltype}{2}{1}(:,5);
    y = data.ds_set{modeltype}{2}{2}(:,7);
    dvalues(modeltype-2,2) = (mean(y) - mean(x))/sqrt((std(x)^2 + std(y)^2)/2);
end
save dvalues dvalues
% in R (option: % alternative="greater" for result1, alternative="less" for result2)
setwd("C:.../probtask_ttest3")
z1 <- matrix(0, nrow=4, ncol=2)
for(i in 3:6) {
    s <- as.character(i)
    read_name1 <- paste0("TDRPE_task1_R1_", s, ".csv")
    read_name2 <- paste0("TDRPE_task1_R2_", s, ".csv")
    read_name3 <- paste0("TDRPE_task2_R1_", s, ".csv")
    read_name4 <- paste0("TDRPE_task2_R2_", s, ".csv")
    data1 <-read.csv(read_name1, header=F)
    data2 <-read.csv(read_name2, header=F)
    data3 <-read.csv(read_name3, header=F)
    data4 <-read.csv(read_name4, header=F)
    result1 <- t.test(x=data1$V1,y=data2$V1,paired=T)
    result2 <- t.test(x=data3$V1,y=data4$V1,paired=T)
    z1[i-2,1] <- result1$p.value
    z1[i-2,2] <- result2$p.value
}
write.csv(z1, "pvalues.csv")
%
pvalues = importdata('pvalues.csv');
