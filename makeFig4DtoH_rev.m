%
clear all
simseed = setrandoms(25010);

%
ndim = 12;
nsim = 100;
for modeltype = 1:5
    for tasktype = 1:2
        for k = 1:2
            data.Vs_set{modeltype}{tasktype}{k} = NaN(nsim,8);
            data.ds_set{modeltype}{tasktype}{k} = NaN(nsim,8);
        end
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',modeltype,tasktype,ksim);
            [os,xs,Vs,ds,trialtypes] = rnrl2lra(modeltype,tasktype,0.1,0.8,ndim,1000,0);
            for k = 1:2
                tmp_last_cue = find(trialtypes==k,1,'last');
                data.Vs_set{modeltype}{tasktype}{k}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
                data.ds_set{modeltype}{tasktype}{k}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
            end
        end
    end
end
save(['data_lrmakeFig4DtoH_' num2str(simseed)],'data');

%
tmp_DEFGH = 'DEFGH';
for modeltype = 1:5
    for tasktype = 1:2
        F = figure;
        A = axes;
        hold on;
        axis([-2 5 -0.6 0.8]);
        P = plot([-2 5],[0 0],'k:');
        P = errorbar([-2:5],mean(data.ds_set{modeltype}{tasktype}{1},1),...
            std(data.ds_set{modeltype}{tasktype}{1},0,1)/sqrt(nsim),'r--');
        P = plot([-2:5],mean(data.ds_set{modeltype}{tasktype}{1},1),'r');
        P = errorbar([-2:5],mean(data.ds_set{modeltype}{tasktype}{2},1),...
            std(data.ds_set{modeltype}{tasktype}{2},0,1)/sqrt(nsim),'b--');
        P = plot([-2:5],mean(data.ds_set{modeltype}{tasktype}{2},1),'b');
        set(A,'XTick',[-2:5],'YTick',[-0.6:0.2:0.8],'FontSize',40);
        print(F,'-depsc',['Fig4' tmp_DEFGH(modeltype) num2str(tasktype)]);
    end
end
