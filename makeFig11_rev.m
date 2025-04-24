%
clear all
setrand_set = [25004 25005];
invt_set = [1 2];
for k_invt = 1:2
    simseed = setrandoms(setrand_set(k_invt));
    invt = invt_set(k_invt);

    %
    ndim_set = [5:5:40];
    nsim = 100;
    nt = 3000;
    prefdecay = 0.001;
    rmpd{1} = [2 1; 1 1; 2 2];
    rmpd{2} = [2 1; 1 1; 2 1];
    for k0 = 1:2
        data.select1{k0} = NaN(4,length(ndim_set),nsim);
        for k1 = 1:length(ndim_set)
            ndim = ndim_set(k1);
            P_set = NaN(ndim,ndim+4,nsim);
            for modeltype = 3:5
                for ksim = 1:nsim
                    fprintf('%d-%d-%d-%d\n',k0,k1,modeltype,ksim);
                    [os,xs,Vs,ds,wbcos,P] = rnrl101cosaslra(modeltype,0.1,invt,0.8,prefdecay,ndim,nt,rmpd{k0},[],0);
                    if modeltype == 4
                        P_set(:,:,ksim) = P;
                    end
                    tmp_choices = os(3,:) + 2*os(4,:);
                    tmp_choices = tmp_choices(tmp_choices>0);
                    data.select1{k0}(modeltype-2,k1,ksim) = sum(tmp_choices(nt-100+1:nt) == 1)/100;
                end
            end
            for modeltype = 5
                for ksim = 1:nsim
                    fprintf('%d-%d-%d-%d\n',k0,k1,modeltype+1,ksim);
                    tmp_P = reshape(P_set(:,:,ksim),ndim*(ndim+4),1);
                    tmp_P = tmp_P(randperm(ndim*(ndim+4)));
                    P = reshape(tmp_P,ndim,ndim+4);
                    [os,xs,Vs,ds,wbcos,P] = rnrl101cosaslra(modeltype,0.1,invt,0.8,prefdecay,ndim,nt,rmpd{k0},P,0);
                    tmp_choices = os(3,:) + 2*os(4,:);
                    tmp_choices = tmp_choices(tmp_choices>0);
                    data.select1{k0}(4,k1,ksim) = sum(tmp_choices(nt-100+1:nt) == 1)/100;
                end
            end
        end
    end
    save(['data_lrmakeFig11_' num2str(invt) '_' num2str(simseed)],'data');

    %
    tmp_colors = 'rbym';
    nsim = 100;
    for k1 = 1:2
        F = figure;
        A = axes;
        hold on;
        axis([0 45 0 1]);
        P = plot([0 45],[0.5 0.5],'k:');
        for k2 = 1:4
            P1 = errorbar([5:5:40],mean(data.select1{k1}(k2,:,:),3),std(data.select1{k1}(k2,:,:),0,3)/sqrt(nsim),[tmp_colors(k2) '--']);
            P2 = plot([5:5:40],mean(data.select1{k1}(k2,:,:),3),tmp_colors(k2));
            if k2 == 3
                set(P1,'Color',0.5*[1 1 1]);
                set(P2,'Color',0.5*[1 1 1]);
            elseif k2 == 4
                set(P1,'Color',0.5*[1 1 1]);
                set(P2,'Color',0.5*[1 1 1]);
                set(P2,'LineStyle','--');
            end
        end
        set(A,'XTick',[5:5:40],'XTickLabel',[5:5:40],'YTick',[0:0.1:1],'YTickLabel',[0:0.1:1],'FontSize',40);
        print(F,'-depsc',['Fig11-' num2str(invt) '-' num2str(k1)]);
    end

end