% for pp=1:5
    %Comparing Beneficial, Neutral and Deleterious CAFI 
    phiVals=[-0.5,0,0.5];
    nPhi=length(phiVals);
    indVals=zeros(1,nPhi);
    % %Picking out our densities from our library
    % for j=1:nPhi
    %     indVals(j)=find(phi_g==phiVals(j) & phi_L==phiVals(j));
    % end
    
    %Picking our distributions that we want to sim
    lamPoisHighD=zeros(nPhi,nr);
    % lamPoisLowD=zeros(nPhi,nr);
    for j=1:nPhi
        lamPoisHighD(j,:)=HalfFilledAreas(end,:,j)*dr;
        % lamPoisLowD(j,:)=LowDSizeDist(end,:,indVals(j))*dr;
    end
    
    lamPoisHighD=lamPoisHighD(:,ind1cm:end);
    lamPoisHighD(:,1)=lamPoisHighD(:,1)/2;lamPoisHighD(:,end)=lamPoisHighD(:,end)/2;
    % lamPoisLowD=lamPoisLowD(:,ind1cm:end);
    % lamPoisLowD(:,1)=lamPoisLowD(:,1)/2;lamPoisLowD(:,end)=lamPoisLowD(:,end)/2;
    
    j=1;
    nCoralSampsHighD=zeros(nPhi,nr-ind1cm+1);
    
    ASamps=zeros(nPhi,1);
    
    while j<nphi+1
        nCoralSampsHighD(j,:)=poissrnd(lamPoisHighD(j,:));
        nHighD=sum(nCoralSampsHighD(j,:),2);
        nonZerosInd=find(nCoralSampsHighD(j,:)>0);
        nNonZeros=length(nonZerosInd);
        rSampsHighDTemp=NaN(1,nHighD);
        indTemp=1;
        for k=1:nNonZeros
            nCorals=nCoralSampsHighD(j,nonZerosInd(k));
            rVals=rdata_mat(nonZerosInd(k))*ones(nCorals,1);
            rSampsHighDTemp(indTemp:indTemp+nCorals-1)=rVals;
            indTemp=indTemp+nCorals;
        end
        rSampsHighDTemp(1:nHighD)=sort(rSampsHighDTemp(1:nHighD),'descend');
    
        %Area check, we will accept between 47-53%
        ALowerB=48;
        AUpperB=52;
        rSampsAreaCheck=rSampsHighDTemp;
        rSampsAreaCheck(isnan(rSampsAreaCheck))=0;
        Acheck=(100*pi/A_total)*sum(rSampsAreaCheck.^2,2);
    
        
        if Acheck > ALowerB && Acheck < AUpperB
                ASamps(j)=Acheck;
                disp(['Sampled approx 50% for phi =',num2str(phiVals(j))]);
                if j==1
                    rSampsHighD=rSampsHighDTemp;
                    nHighDCheck=nHighD;
                    nHighDStore=nHighD;
                elseif nHighD<nHighDCheck
                    nHighDStore=[nHighDStore;nHighD];
                    rSampTemp=NaN(j,nHighDCheck);
                    for jj=1:j-1
                        rSampTemp(jj,1:nHighDStore(jj))=rSampsHighD(jj,1:nHighDStore(jj));
                    end
                    rSampTemp(j,1:nHighDStore(j))=rSampsHighDTemp(1:nHighDStore(j));
                    rSampsHighD=rSampTemp;
                else 
                     nHighDCheck=nHighD;
                     nHighDStore=[nHighDStore;nHighD];
                     rSampTemp=NaN(j,nHighDCheck);
                    for jj=1:j-1
                        rSampTemp(jj,1:nHighDStore(jj))=rSampsHighD(jj,1:nHighDStore(jj));
                    end
                    rSampTemp(j,1:nHighDStore(j))=rSampsHighDTemp(1:nHighDStore(j));
                    rSampsHighD=rSampTemp;
                end
                j=j+1;
        end
    end
    
    
        
    
    % nCoralSampsHighD=poissrnd(lamPoisHighD);
    % nHighD=sum(nCoralSampsHighD,2);
    % % nCoralSampsLowD=poissrnd(lamPoisLowD);
    % % nLowD=sum(nCoralSampsLowD,2);
    
    
    % rSampsHighD=NaN(nPhi,max(nHighD));
    % for j=1:nPhi
    %     nonZerosInd=find(nCoralSampsHighD(j,:)>0);
    %     nNonZeros=length(nonZerosInd);
    %     indTemp=1;
    %     for k=1:nNonZeros
    %         nCorals=nCoralSampsHighD(j,nonZerosInd(k));
    %         rVals=rdata_mat(nonZerosInd(k))*ones(nCorals,1);
    %         rSampsHighD(j,indTemp:indTemp+nCorals-1)=rVals;
    %         indTemp=indTemp+nCorals;
    %     end
    % 
    % end
    
    % rSampsLowD=NaN(nPhi,max(nLowD));
    % for j=1:nPhi
    %     nonZerosInd=find(nCoralSampsLowD(j,:)>0);
    %     nNonZeros=length(nonZerosInd);
    %     indTemp=1;
    %     for k=1:nNonZeros
    %         nCorals=nCoralSampsLowD(j,nonZerosInd(k));
    %         rVals=rdata_mat(nonZerosInd(k))*ones(nCorals,1);
    %         rSampsLowD(j,indTemp:indTemp+nCorals-1)=rVals;
    %         indTemp=indTemp+nCorals;
    %     end
    % end
    
    % for j=1:nPhi
    %     rSampsHighD(j,1:nHighD(j))=sort(rSampsHighD(j,1:nHighD(j)),'descend');
    %     % rSampsLowD(j,1:nLowD(j))=sort(rSampsLowD(j,1:nLowD(j)),'descend');
    % end
    % 
    % rCheck=rSampsHighD;
    % rCheck(isnan(rCheck))=0;
    % Acheck=(100*pi/A_total)*sum(rCheck.^2,2)
    
    
    
    reDrawOverlap=0;
    xValsHighD=NaN(nPhi,max(nHighDStore));
    yValsHighD=NaN(nPhi,max(nHighDStore));
    
    
    % xValsLowD=NaN(nPhi,max(nLowD));
    % yValsLowD=NaN(nPhi,max(nLowD));
    
    % nHighDPrev=nHighD;
    % nLowDPrev=nLowD;
    figure()
    j=1;
    reDrawLim=20000;
    
    while j<nPhi+1
        check=1;
        reDrawOB=0;
        while check<nHighDStore(j)+1
            locations=unifrnd(0,10*100,[2,1]);
            xValsHighD(j,check)=locations(1);yValsHighD(j,check)=locations(2);
            if xValsHighD(j,check)<rSampsHighD(j,check) || yValsHighD(j,check)<rSampsHighD(j,check)...
                    || xValsHighD(j,check)>1000-rSampsHighD(j,check) || yValsHighD(j,check)>1000-rSampsHighD(j,check)
                reDrawOB=reDrawOB+1
                if reDrawOB<reDrawLim
                    continue
                else
                    check=nHighDStore(j)+1;
                end
            end
            if check==1
                check=check+1;
            else
               dist=(xValsHighD(j,1:check-1)-xValsHighD(j,check)).^2+(yValsHighD(j,1:check-1)-yValsHighD(j,check)).^2;
               rSumsHighD=(rSampsHighD(j,1:check-1)+rSampsHighD(j,check)).^2;
               overlap=sum(dist<rSumsHighD);
               if overlap==0
                   check=check+1;
               else
                   reDrawOverlap=reDrawOverlap+1;
               end
            end
        end
    
        if reDrawOverlap<reDrawLim
            subplot(1,3,j)
        if j==1
            title('Deleterious CAFI', 'FontWeight','normal')
            xlabel(['Sim. cover: ',num2str(round(ASamps(j),1)),' %'])
            % ylabel('50% Coverage in different regimes','FontSize', 18,'FontWeight','bold')
        elseif j==2
            title('Neutral CAFI','FontWeight','normal')
            xlabel(['Sim. cover: ',num2str(round(ASamps(j),1)),' %'])
        elseif j==3
            title('Beneficial CAFI','FontWeight','normal')
            xlabel(['Sim. cover: ',num2str(round(ASamps(j),1)),' %'])
        end
        for jj=1:nHighDStore(j)
            coral=nsidedpoly(1000,'Center',[xValsHighD(j,jj)/100,yValsHighD(j,jj)/100],'Radius',rSampsHighD(j,jj)/100);
            hold on
            plot(coral, 'FaceColor',[0 0.4470 0.7410])
        end
        xlim([0,10])
        ylim([0,10])
        xticklabels({})
        yticklabels({})
        axis square
        j=j+1;
        else
            continue
        end       
    end
    sgtitle('Comparing half coverage accross CAFI effects','FontSize',25,'FontWeight','bold')
% end
% for j=1:nPhi
%     check=1;
%     reDrawOB=0;
%     while check<nHighD(j)+1
%         locations=unifrnd(0,10*100,[2,1]);
%         xValsHighD(j,check)=locations(1);yValsHighD(j,check)=locations(2);
%         if xValsHighD(j,check)<rSampsHighD(j,check) || yValsHighD(j,check)<rSampsHighD(j,check)...
%                 || xValsHighD(j,check)>1000-rSampsHighD(j,check) || yValsHighD(j,check)>1000-rSampsHighD(j,check)
%             reDrawOB=reDrawOB+1
%             if reDrawOB<50000
%                 continue
%             else
%                 nHighD(j)=check;
%             end
%         end
%         if check==1
%             check=check+1;
%         else
%            dist=(xValsHighD(j,1:check-1)-xValsHighD(j,check)).^2+(yValsHighD(j,1:check-1)-yValsHighD(j,check)).^2;
%            rSumsHighD=(rSampsHighD(j,1:check-1)+rSampsHighD(j,check)).^2;
%            overlap=sum(dist<rSumsHighD);
%            if overlap==0
%                check=check+1;
%            else
%                reDrawOverlap=reDrawOverlap+1;
%            end
%         end
%     end
%     subplot(1,3,j)
%     if j==1
%         title('Deleterious CAFI','FontSize',20)
%         xlabel(['Sim. cover: ',num2str(round(Acheck(j),1)),' %'])
%         % ylabel('50% Coverage in different regimes','FontSize', 18,'FontWeight','bold')
%     elseif j==2
%         title('Neutral CAFI','FontSize',20)
%         xlabel(['Sim. cover: ',num2str(round(Acheck(j),1)),' %'])
%     elseif j==3
%         title('Beneficial CAFI','FontSize',20)
%         xlabel(['Sim. cover: ',num2str(round(Acheck(j),1)),' %'])
%     end
%     for jj=1:nHighD(j)
%         coral=nsidedpoly(1000,'Center',[xValsHighD(j,jj)/100,yValsHighD(j,jj)/100],'Radius',rSampsHighD(j,jj)/100);
%         hold on
%         plot(coral, 'FaceColor',[0 0.4470 0.7410])
%     end
%     xlim([0,10])
%     ylim([0,10])
%     xticklabels({})
%     yticklabels({})
%     axis square

    % 
    % check=1;
    % reDrawOB=0;
    % while check<nLowD(j)+1
    %     locations=unifrnd(0,m*100,[2,1]);
    %     xValsLowD(j,check)=locations(1);yValsLowD(j,check)=locations(2);
    %     if xValsLowD(j,check)<rSampsLowD(j,check) || yValsLowD(j,check)<rSampsLowD(j,check) ...
    %                || xValsLowD(j,check)>1000-rSampsLowD(j,check) || yValsLowD(j,check)>1000-rSampsLowD(j,check)
    %         reDrawOB=reDrawOB+1
    %         continue
    %     end
    %     if check==1
    %         check=check+1;
    %     else
    %        dist=(xValsLowD(j,1:check-1)-xValsLowD(j,check)).^2+(yValsLowD(j,1:check-1)-yValsLowD(j,check)).^2;
    %        rSumsLowD=(rSampsLowD(j,1:check-1)+rSampsLowD(j,check)).^2;
    %        overlap=sum(dist<rSumsLowD);
    %        if overlap==0
    %            check=check+1;
    %        else
    %            reDrawOverlap=reDrawOverlap+1;
    %        end
    %     end
    % end
    % subplot(2,3,nPhi+j)
    % if j==1
    %     ylabel('Low immigration','FontSize', 18,'FontWeight',...
    %         'bold')
    % 
    % end
    % for jj=1:nLowD(j)
    %     coral=nsidedpoly(1000,'Center',[xValsLowD(j,jj)/100,yValsLowD(j,jj)/100],'Radius',rSampsLowD(j,jj)/100);
    %     hold on
    %     plot(coral, 'FaceColor',[0 0.4470 0.7410])
    % end
    % xlim([0,10])
    % ylim([0,10])
    % xticklabels({})
    % yticklabels({})
    % axis square
% end
% sgtitle({'Comparing ``50``% coverage', 'accross CAFI effects'},'FontSize',22,'FontWeight','bold')

% rCheck=rSampsHighD;
% rCheck(isnan(rCheck))=0;
% Acheck=(100*pi/A_total)*sum(rCheck.^2,2)
