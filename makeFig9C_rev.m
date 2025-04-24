%
clear all
simseed = setrandoms(25002);

%
ndim = 20;
nsim = 100;
Pe_set = NaN(ndim,ndim+2,2,nsim);
Pi_set = NaN(ndim,ndim+2,2,nsim);
for modeltype = 3:5
    for tasktype = 1:2
        for k = 1:2
            data.Vs_set{modeltype}{tasktype}{k} = NaN(nsim,8);
            data.ds_set{modeltype}{tasktype}{k} = NaN(nsim,8);
        end
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',modeltype,tasktype,ksim);
            [os,xs,xis,Vs,ds,trialtypes,P] = rnrl102eilra(modeltype,tasktype,0.1,0.8,ndim,2000,[],0);
            if modeltype == 4
                Pe_set(:,:,tasktype,ksim) = P.e;
                Pi_set(:,:,tasktype,ksim) = P.i;
            end
            for k = 1:2
                tmp_last_cue = find(trialtypes==k,1,'last');
                data.Vs_set{modeltype}{tasktype}{k}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
                data.ds_set{modeltype}{tasktype}{k}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
            end
        end
    end
end
for modeltype = 5
    for tasktype = 1:2
        for k = 1:2
            data.Vs_set{modeltype+1}{tasktype}{k} = NaN(nsim,8);
            data.ds_set{modeltype+1}{tasktype}{k} = NaN(nsim,8);
        end
        for ksim = 1:nsim
            fprintf('%d-%d-%d\n',modeltype+1,tasktype,ksim);
            tmp_Pe = reshape(Pe_set(:,:,tasktype,ksim),ndim*(ndim+2),1);
            tmp_Pe = tmp_Pe(randperm(ndim*(ndim+2)));
            Pe = reshape(tmp_Pe,ndim,ndim+2);
            tmp_Pi = reshape(Pi_set(:,:,tasktype,ksim),ndim*(ndim+2),1);
            tmp_Pi = tmp_Pi(randperm(ndim*(ndim+2)));
            Pi = reshape(tmp_Pi,ndim,ndim+2);
            P.e = Pe;
            P.i = Pi;
            [os,xs,xis,Vs,ds,trialtypes,P] = rnrl102eilra(modeltype,tasktype,0.1,0.8,ndim,2000,P,0);
            for k = 1:2
                tmp_last_cue = find(trialtypes==k,1,'last');
                data.Vs_set{modeltype+1}{tasktype}{k}(ksim,:) = Vs(tmp_last_cue-2:tmp_last_cue+5);
                data.ds_set{modeltype+1}{tasktype}{k}(ksim,:) = ds(tmp_last_cue-2:tmp_last_cue+5);
            end
        end
    end
end
save(['data_lrmakeFig9C_' num2str(simseed)],'data');

%
for modeltype = 3:6
    for tasktype = 1:2
        F = figure;
        A = axes;
        hold on;
        axis([-2 5 -0.6 1.2]);
        P = plot([-2 5],[0 0],'k:');
        P = errorbar([-2:5],mean(data.ds_set{modeltype}{tasktype}{1},1),...
            std(data.ds_set{modeltype}{tasktype}{1},0,1)/sqrt(nsim),'r--');
        P = plot([-2:5],mean(data.ds_set{modeltype}{tasktype}{1},1),'r');
        P = errorbar([-2:5],mean(data.ds_set{modeltype}{tasktype}{2},1),...
            std(data.ds_set{modeltype}{tasktype}{2},0,1)/sqrt(nsim),'b--');
        P = plot([-2:5],mean(data.ds_set{modeltype}{tasktype}{2},1),'b');
        set(A,'XTick',[-2:5],'YTick',[-0.6:0.2:1.2],'FontSize',40);
        print(F,'-depsc',['Fig9C_' num2str(modeltype-2) '-' num2str(tasktype)]);
    end
end
