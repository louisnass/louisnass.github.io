%%Numerical Propagule Redirection

lam0=10^(-5);
mu=0.004;

%Specify the landscape
%Number of corals in the center
focal=2;%2;1;0;

%Circle of corals
circle='y';%'y';'n';

% figure()
if circle=='y'
    %Number of neighbors
    nNeighbors=10;
    distNeighbor=100;
    rNeighbor=1;
    indNeighbor=find(R==rNeighbor);
    RStarNeighbor=Rstar(indNeighbor);
    if nNeighbors>0
        %Place the neighbors in a circle around the origin evenly spaced 
        dtheta=2*pi/nNeighbors;
        theta=0:dtheta:2*pi-dtheta;
        xNeighbors=distNeighbor.*cos(theta)';
        yNeighbors=distNeighbor.*sin(theta)';
    
        %For computing the CAFI attracted to the neighbors
        xNeighborsFocal=xNeighbors(2:end);
        yNeighborsFocal=yNeighbors(2:end);

        LNeighborFocal=2*RStarNeighbor;
        HNeighborFocal=2*RStarNeighbor;
        ANeighborFocal=LNeighborFocal*HNeighborFocal;

        % for jj=1:nNeighbors
        %     coral=nsidedpoly(1000,'Center',[xNeighbors(jj)/100,yNeighbors(jj)/100],'Radius',rNeighbor/100);
        %     hold on
        %     plot(coral, 'FaceColor',[0 0.4470 0.7410])
        % end
    end
elseif circle=='n'
    nNeighbors=0;
else
    Error('Specify surrounding corals')
end

if focal>0
    %Focal coral size, we place our focal/s in the origin
    rFocal=1;
    indFocal=find(R==rFocal);
    RStarFocal=Rstar(indFocal);
    if focal==1
        xFocalCent=0;
        yFocalCent=0;

        LFocal=2*RStarFocal;
        HFocal=2*RStarFocal;
        AFocal=LFocal*HFocal;

        xNeighborsFocal=[xNeighborsFocal;xFocalCent];
        yNeighborsFocal=[yNeighborsFocal;yFocalCent];
        % coral=nsidedpoly(1000,'Center',[xFocalCent/100,yFocalCent/100],'Radius',rFocal/100);
        % hold on
        % plot(coral, 'FaceColor',[0 0.4470 0.7410])
        % hold on
        % xlim([-(distNeighbor+rNeighbor),distNeighbor+rNeighbor])
        % ylim([-(distNeighbor+rNeighbor),distNeighbor+rNeighbor])
        % xticklabels({})
        % yticklabels({})
        % axis square
    elseif focal==2
        xFocalCent=rFocal;
        yFocalCent=0;

        LFocal=2*RStarFocal;
        HFocal=2*RStarFocal;
        AFocal=LFocal*HFocal;
        
        xNeighbors=[xNeighbors;-xFocalCent];
        yNeighbors=[yNeighbors;yFocalCent];
        
        xNeighborsFocal=[xNeighborsFocal;xFocalCent];
        yNeighborsFocal=[yNeighborsFocal;yFocalCent];

        xNeighborsFocal=[xNeighborsFocal;-xFocalCent];
        yNeighborsFocal=[yNeighborsFocal;yFocalCent];

        nNeighbors=nNeighbors+1;

        % coral=nsidedpoly(1000,'Center',[xFocalCent/100,yFocalCent/100],'Radius',rFocal/100);
        % hold on
        % plot(coral, 'FaceColor',[0 0.4470 0.7410])
        % coral=nsidedpoly(1000,'Center',[-xFocalCent/100,yFocalCent/100],'Radius',rFocal/100);
        % hold on
        % plot(coral, 'FaceColor',[0 0.4470 0.7410])
        % hold on
        % xlim([-(distNeighbor+rNeighbor),distNeighbor+rNeighbor])
        % ylim([-(distNeighbor+rNeighbor),distNeighbor+rNeighbor])
        % xticklabels({})
        % yticklabels({})
    else
        Error('Specify Number of Focal Corals')
    end
end
locations=[xNeighbors,yNeighbors];
locations=[xFocalCent,yFocalCent;locations];
radiusData=ones(12,1);
treatment=['N';'N';'N';'N';'N';'N';'N';'N';'N';'N';'N';'N'];
[landscape,coralCAFISettlersData]=coralSettlers(locations,radiusData,c,X0,Rstar,mu,lam0,treatment);

coralCAFISettlersData

% xlim([-1.1,1.1])
% ylim([-1.1,1.1])
% axis square
% 
% lamBarFocal=zeros(focal,1);
% lamBarIso=zeros(focal,1);
% lamBarNeighbor=zeros(nNeighbors,1);
% 
% 
% nSamps=100000;
% 
% if focal>0
%     %Sampling accross our region uniformly in x and y
%     xSamps=unifrnd(-RStarFocal,RStarFocal,1,nSamps)+xFocalCent;
%     ySamps=unifrnd(-RStarFocal,RStarFocal,1,nSamps)+yFocalCent;
% 
%     %Computing distances of our sample with the origin 
%     sampFocalDist=sqrt((xSamps-xFocalCent).^2+(ySamps-yFocalCent).^2);
%     %Distances from edges of our corals
%     sampFocalEdgeDist=sampFocalDist-rFocal;
%     %If on the edge or on the coral, we denote that with distance 0
%     sampFocalEdgeDist(sampFocalEdgeDist<X0(1))=0;
% 
%     %Initialize chemical contribution for our focal coral
%     cFocal=zeros(1,nSamps);
% 
%     disp('Identifying chemical for samples on focal coral')
%     %Checking and denoting chemical for CAFI in or on edge of focal coral
%     onFocalChk=sum(sampFocalEdgeDist==0);
%     if onFocalChk>0
%         indOnFocal=find(sampFocalEdgeDist==0);
%         cFocal(indOnFocal)=c(indFocal,1);
%     end
% 
%     disp('Identifying chemical for samples in threshold annulus')
%     %Checking and denoting chemical contribution for CAFI in the chemical threshold
%     %range
%     deltaFocalChk=sum(sampFocalEdgeDist>=X0(1) & sampFocalEdgeDist<=RStarFocal-rFocal);
%     if deltaFocalChk>0
%         indDeltaFocal=find(sampFocalEdgeDist>=X0(1) & sampFocalEdgeDist<=RStarFocal-rFocal);
%         indChemFocal=sum(sampFocalEdgeDist(indDeltaFocal)'>=X0,2);
%         cFocal(indDeltaFocal)=c(indFocal,indChemFocal);
%     end
% 
% 
%     %Weight this chemical contribution by travel distance to the edge of
%     %our focal coral
%     disp('Computing chemical weighted by distance from coral edge')
%     cFocalTravel=cFocal.*exp(-mu.*sampFocalEdgeDist);
% 
%     %Computing chemical contribution from neighbors
%     if nNeighbors>0
% 
%         %Computing CAFI distances from neighboring corals
%         sampNeighborDist=sqrt((xSamps-xNeighbors).^2+(ySamps-yNeighbors).^2);
% 
%         if focal<2
%             %Distance from edges of neighbor corals
%             sampNeighborEdgeDist=sampNeighborDist-rNeighbor;
%         else
%             sampNeighborEdgeDist=sampNeighborDist(1:end-1,:)-rNeighbor;
%             sampNeighborEdgeDist=[sampNeighborEdgeDist;sampNeighborDist(end,:)-rFocal];
%         end
%         %If in or on edge of coral, distance is 0
%         sampNeighborEdgeDist(sampNeighborEdgeDist<X0(1))=0;
% 
%         %Compute chemical contribution from each neighbor
%         cNeighbor=zeros(nNeighbors,nSamps);
%         for jj=1:nNeighbors
%             disp(['Identifying chemical contribution from neighbor ',num2str(jj),' out of ',num2str(nNeighbors),' corals'])
%             %Checking and denoting chemical for CAFI in or on edge of
%             %neighbor
%             onNeighborChk=sum(sampNeighborEdgeDist(jj,:)==0);
%             if onNeighborChk>0
%                 indOnNeighbor=find(sampNeighborEdgeDist(jj,:)==0);
%                 if focal==2 && jj==nNeighbors
%                     cNeighbor(jj,indOnNeighbor)=c(indFocal,1);
%                 else
%                     cNeighbor(jj,indOnNeighbor)=c(indNeighbor,1);
%                 end
%             end
% 
%             %Checking and denoting chemical for CAFI in threshold range of
%             %neighboring coral
%             if focal==2 && jj==nNeighbors
%                 deltaNeighborChk=sum(sampNeighborEdgeDist(jj,:)>=X0(1) & ...
%                     sampNeighborEdgeDist(jj,:)<=RStarFocal-rFocal);
%             else
%                 deltaNeighborChk=sum(sampNeighborEdgeDist(jj,:)>=X0(1) & ...
%                     sampNeighborEdgeDist(jj,:)<=RStarNeighbor-rNeighbor);
%             end
% 
%             if deltaNeighborChk>0
%                 if focal==2 && jj==nNeighbors
%                     indDeltaNeighbor=find(sampNeighborEdgeDist(jj,:)>=X0(1) & ...
%                         sampNeighborEdgeDist(jj,:)<=RStarFocal-rFocal);
%                     indChemNeighbor=sum(sampNeighborEdgeDist(jj,indDeltaNeighbor)'>=X0,2);
%                     cNeighbor(jj,indDeltaNeighbor)=c(indFocal,indChemNeighbor);
%                 else
%                     indDeltaNeighbor=find(sampNeighborEdgeDist(jj,:)>=X0(1) & ...
%                         sampNeighborEdgeDist(jj,:)<=RStarNeighbor-rNeighbor);
%                     indChemNeighbor=sum(sampNeighborEdgeDist(jj,indDeltaNeighbor)'>=X0,2);
%                     cNeighbor(jj,indDeltaNeighbor)=c(indNeighbor,indChemNeighbor);
%                 end
% 
%             end
%         end
%        cNeighborSum=sum(cNeighbor,1); 
%     else 
%         cNeighborSum=0;
%     end
% 
%     %Integrand
%     F=cFocalTravel./(cFocal+cNeighborSum);
%     F(isnan(F))=0;
%     %Estimate of Average number of settlers to focal coral
%     lamBarFocal=(lam0*AFocal/(nSamps))*sum(F);
%     %Average number of settlers to isolated focal coral
%     lamBarIso=lam0*(pi*rFocal^2+(2*pi/mu^2).*(mu.*rFocal+1-...
%         (mu*(RStarFocal)+1).*exp(-mu*(RStarFocal-rFocal))));
%     disp(['Average number of fish for focal in the landscape = ', num2str(lamBarFocal)])
%     disp(['Average number of fish for focal in isolation = ', num2str(lamBarIso)])
%     disp(['Ratio =', num2str(lamBarFocal/lamBarIso)]);
% end
% 
% if focal==0
%     nNeighbors=nNeighbors-1;
% end
% 
% if circle=='y'
%     disp('Computing average number of fish for a neighboring coral')
%     %Sampling accross our region uniformly in x and y
%     xSamps=unifrnd(-RStarNeighbor,RStarNeighbor,1,nSamps)+xNeighbors(1);
%     ySamps=unifrnd(-RStarNeighbor,RStarNeighbor,1,nSamps)+yNeighbors(1);
% 
%     %Computing distances of our samples with the focal neighbor 
%     sampNeighborFocalDist=sqrt((xSamps-xNeighbors(1)).^2+(ySamps-yNeighbors(1)).^2);
%     %Distances from edges of our corals
%     sampNeighborFocalEdgeDist=sampNeighborFocalDist-rNeighbor;
%     %If on the edge or on the coral, we denote that with distance 0
%     sampNeighborFocalEdgeDist(sampNeighborFocalEdgeDist<X0(1))=0;
% 
%     %Initialize chemical contribution for our focal coral
%     cNeighborFocal=zeros(1,nSamps);
% 
%     %Checking and denoting chemical for CAFI in or on edge of focal coral
%     disp('Identifying chemical for samples on neighbor coral')
%     onNeighborFocalChk=sum(sampNeighborFocalEdgeDist==0);
%     if onNeighborFocalChk>0
%         indOnNeighborFocal=find(sampNeighborFocalEdgeDist==0);
%         cNeighborFocal(indOnNeighborFocal)=c(indNeighbor,1);
%     end
% 
%     %Checking and denoting chemical contribution for CAFI in the chemical threshold
%     %range
%     disp('Identifying chemical for samples in threshold annulus of neighbor')
%     deltaNeighborFocalChk=sum(sampNeighborFocalEdgeDist>=X0(1) & sampNeighborFocalEdgeDist<=RStarNeighbor-rNeighbor);
%     if deltaNeighborFocalChk>0
%         indDeltaNeighborFocal=find(sampNeighborFocalEdgeDist>=X0(1) & sampNeighborFocalEdgeDist<=RStarNeighbor-rNeighbor);
%         indChemNeighborFocal=sum(sampNeighborFocalEdgeDist(indDeltaNeighborFocal)'>=X0,2);
%         cNeighborFocal(indDeltaNeighborFocal)=c(indNeighbor,indChemNeighborFocal);
%     end
% 
%     %Weight this chemical contribution by travel distance to the edge of
%     %our focal coral
%     disp('Computing chemical weighted by distance from coral edge')
%     cNeighborFocalTravel=cNeighborFocal.*exp(-mu.*sampNeighborFocalEdgeDist);
% 
%     %Computing chemical contribution from neighbors
%     if nNeighbors>0
%          %Computing CAFI distances from neighboring corals
%          sampFocalNeighborDist=sqrt((xSamps-xNeighborsFocal).^2+(ySamps-yNeighborsFocal).^2);
% 
%          %Distance from edges of neighbor corals
%          sampFocalNeighborEdgeDist=sampFocalNeighborDist-rNeighbor;
%          if focal>0 
%              sampFocalNeighborEdgeDist(end-focal+1:end,:)=sampFocalNeighborDist(end-focal+1:end,:)-rFocal;
%          end
%          %If in or on edge of coral, distance is 0
%          sampFocalNeighborEdgeDist(sampFocalNeighborEdgeDist<X0(1))=0;
% 
%          %Compute chemical contribution from each neighbor
%          cFocalNeighbor=zeros(nNeighbors,nSamps);
% 
%          for jj=1:nNeighbors
%              disp(['Identifying chemical contribution from other neighbor ',num2str(jj),' out of ',num2str(nNeighbors),' corals'])
%             %Checking and denoting chemical for CAFI in or on edge of
%             %neighbor
%             onFocalNeighborChk=sum(sampFocalNeighborEdgeDist(jj,:)==0);
%             if onFocalNeighborChk>0
%                 indOnFocalNeighbor=find(sampFocalNeighborEdgeDist(jj,:)==0);
%                 if focal>0 && jj>nNeighbors-focal
%                     cFocalNeighbor(jj,indOnFocalNeighbor)=c(indFocal,1);
%                 else
%                     cFocalNeighbor(jj,indOnFocalNeighbor)=c(indNeighbor,1);
%                 end
%             end
% 
%             %Checking and denoting chemical for CAFI in threshold range of
%             %neighboring coral
%             if focal>0 && jj>nNeighbors-focal
%                 deltaFocalNeighborChk=sum(sampFocalNeighborEdgeDist(jj,:)>=X0(1) & ...
%                     sampFocalNeighborEdgeDist(jj,:)<=RStarFocal-rFocal);
%             else
%                 deltaFocalNeighborChk=sum(sampFocalNeighborEdgeDist(jj,:)>=X0(1) & ...
%                     sampFocalNeighborEdgeDist(jj,:)<=RStarNeighbor-rNeighbor);
%             end
% 
%             if deltaFocalNeighborChk>0
%                 if focal>0 && jj>nNeighbors-focal
%                   indDeltaFocalNeighbor=find(sampFocalNeighborEdgeDist(jj,:)>=X0(1) & ...
%                      sampFocalNeighborEdgeDist(jj,:)<=RStarFocal-rFocal);
%                   indChemFocalNeighbor=sum(sampFocalNeighborEdgeDist(jj,indDeltaFocalNeighbor)'>=X0,2);
%                   cFocalNeighbor(jj,indDeltaFocalNeighbor)=c(indFocal,indChemFocalNeighbor);
%                 else
%                   indDeltaFocalNeighbor=find(sampFocalNeighborEdgeDist(jj,:)>=X0(1) & ...
%                       sampFocalNeighborEdgeDist(jj,:)<=RStarNeighbor-rNeighbor);
%                   indChemFocalNeighbor=sum(sampFocalNeighborEdgeDist(jj,indDeltaFocalNeighbor)'>=X0,2);
%                   cFocalNeighbor(jj,indDeltaFocalNeighbor)=c(indNeighbor,indChemFocalNeighbor);
%                 end        
%             end
%          end
%         %Getting the total neighbor contribution at each point in the
%         %samples 
%         cFocalNeighborSum=sum(cFocalNeighbor,1);
%     else
%         cFocalNeighborSum=0;
%     end
% 
%     %Integrand
%     FNeighbor=cNeighborFocalTravel./(cNeighborFocal+cFocalNeighborSum);
%     FNeighbor(isnan(FNeighbor))=0;
%     %Estimate of Average number of settlers to focal coral
%     lamBarNeighbor=(lam0*ANeighborFocal/(nSamps))*sum(FNeighbor);
%     %Average number of settlers to isolated focal coral
%     lamBarIsoNeighbor=lam0*(pi*rNeighbor^2+(2*pi/mu^2).*(mu.*rNeighbor+1-...
%         (mu*(RStarNeighbor)+1).*exp(-mu*(RStarNeighbor-rNeighbor))));
%     disp(['Average number of fish for neighbor in the landscape = ', num2str(lamBarNeighbor)])
%     disp(['Average number of fish for focal in isolation = ', num2str(lamBarIsoNeighbor)])
%     disp(['Ratio =', num2str(lamBarNeighbor/lamBarIsoNeighbor)]);
% end
% 
% 
% 
% 
% 
% 
% % for j=1:nRFocal
% %     %We must find the index of our focal for reference
% %     indFocal=find(R==rFocal(j));
% %     L=2*Rstar(rFocal(j))+2;
% %     H=2*Rstar(rFocal(j));
% % 
% %     AQuad=L*H;
% % 
% %     %Finding the indices of our neighbor radius for chemical translation
% %     indNeighbor=find(R==rNeighbor(j));
% % 
% %     %Sampling accross our region uniformly in x and y
% %     nSamps=1000000;
% %     xSamps=unifrnd(-Rstar(indFocal)-1,Rstar(indFocal)+1,1,nSamps);
% %     ySamps=unifrnd(-Rstar(indFocal),Rstar(indFocal),1,nSamps);
% % 
% %     %Computing distances of our sample with the origin 
% %     sampFocalDist=sqrt((xSamps-xFocalCent1).^2+(ySamps-yFocalCent1).^2);
% %     %Distances from edges of our corals
% %     sampFocalEdgeDist=sampFocalDist-R(indFocal);
% %     %If on the edge or on the coral, we denote that with distance 0
% %     sampFocalEdgeDist(sampFocalEdgeDist<X0(1))=0;
% % 
% %     %Initialize chemical contribution for our focal coral
% %     cFocal=zeros(1,nSamps);
% % 
% %     %Checking and denoting chemical for CAFI in or on edge of focal coral
% %     onFocalChk=sum(sampFocalEdgeDist==0);
% %     if onFocalChk>0
% %         indOnFocal=find(sampFocalEdgeDist==0);
% %         cFocal(indOnFocal)=c(indFocal,1);
% %     end
% % 
% %     %Checking and denoting chemical contribution for CAFI in the chemical threshold
% %     %range
% %     deltaFocalChk=sum(sampFocalEdgeDist>=X0(1) & sampFocalEdgeDist<=Rstar(indFocal)-rFocal(j));
% %     if deltaFocalChk>0
% %         indDeltaFocal=find(sampFocalEdgeDist>=X0(1) & sampFocalEdgeDist<=Rstar(indFocal)-rFocal(j));
% %         indChemFocal=sum(sampFocalEdgeDist(indDeltaFocal)>=X0,2);
% %         cFocal(indDeltaFocal)=c(indFocal,indChemFocal);
% %     end
% % 
% %     %Weight this chemical contribution by travel distance to the edge of
% %     %our focal coral
% %     cFocalTravel=cFocal.*exp(-mu.*sampFocalEdgeDist);
% % 
% %     %Computing chemical contribution from neighbors
% %     if nNeighbors>0
% %         %Computing CAFI distances from neighboring corals
% %         sampNeighborDist=sqrt((xSamps-xNeighbors).^2+(ySamps-yNeighbors).^2);
% % 
% %         %Distance from edges of neighbor corals
% %         sampNeighborEdgeDist=sampNeighborDist-R(indNeighbor);
% %         %If in or on edge of coral, distance is 0
% %         sampNeighborEdgeDist(sampNeighborEdgeDist<X0(1))=0;
% % 
% %         %Compute chemical contribution from each neighbor
% %         cNeighbor=zeros(nNeighbors,nSamps);
% %         for jj=1:nNeighbors
% %             %Checking and denoting chemical for CAFI in or on edge of
% %             %neighbor
% %             onNeighborChk=sum(sampNeighborEdgeDist(jj,:)==0);
% %             if onNeighborChk>0
% %                 indOnNeighbor=find(sampNeighborEdgeDist(jj,:)==0);
% %                 cNeighbor(jj,indOnNeighbor)=c(indNeighbor,1);
% %             end
% % 
% %             %Checking and denoting chemical for CAFI in threshold range of
% %             %neighboring coral
% %             deltaNeighborChk=sum(sampNeighborEdgeDist(jj,:)>=X0(1) & ...
% %                 sampNeighborEdge(jj,:)<=Rstar(indNeighbor)-R(indNeighbor));
% %             if deltaNeighborChk>0
% %                 indDeltaNeighbor=find(sampNeighborEdgeDist(jj,:)>=X0(1) & ...
% %                     sampNeighborEdge(jj,:)<=Rstar(indNeighbor)-R(indNeighbor));
% %                 indChemNeighbor=sum(sampNeighborEdgeDist(jj,indDeltaFocal)>=X0,2);
% %                 cNeighbor(jj,indDeltaNeighbor)=c(indNeighbor,indChemNeighbor);
% %             end
% %         end
% % 
% %         %Getting the total neighbor contribution at each point in the
% %         %samples 
% %         cNeighbor=sum(cNeighbor);
% %     else
% %         %No neighbors, hence chemical contribution is 0
% %         cNeighbor=zeros(1,nSamps);
% %     end
% % 
% %     %Integrand
% %     F=cFocalTravel./(cFocal+cNeighbor);
% %     F(isnan(F))=0;
% %     %Estimate of Average number of settlers to focal coral
% %     lamBarFocal(j)=4*(lam0*A/(nSamps))*sum(F);
% %     %Average number of settlers to isolated focal coral
% %     lamBarIso(j)=lam0*(pi*rFocal(j)+(2*pi/mu^2).*(mu.*rFocal(j)+1-...
% %         mu*(Rstar(indFocal)+1).*exp(-mu*deltaX(indFocal))));
% % 
% %     %Compute the settlers to 1 neighbor (multiply by nNeighbors)
% %     if nNeighbors>0
% %         ANeighborFocal=(2*Rstar(indNeighbor))^2;
% % 
% %         %Sampling accross our region uniformly in x and y
% %         nSamps=10000;
% %         xSamps=unifrnd(0,2*Rstar(ind),1,nSamps);
% %         ySamps=unifrnd(-Rstar(indNeighbor),Rstar(indNeighbor),1,nSamps);
% % 
% %         %Computing distances of our samples with the focal neighbor 
% %         sampNeighborFocalDist=sqrt((xSamps-xNeighbors(1)).^2+(ySamps-yNeighbors(1)).^2);
% %         %Distances from edges of our corals
% %         sampNeighborFocalEdgeDist=sampNeighborFocalDist-R(indNeighbor);
% %         %If on the edge or on the coral, we denote that with distance 0
% %         sampNeighborFocalEdgeDist(sampNeighborFocalEdgeDist<X0(1))=0;
% % 
% %         %Initialize chemical contribution for our focal coral
% %         cNeighborFocal=zeros(1,nSamps);
% % 
% %         %Checking and denoting chemical for CAFI in or on edge of focal coral
% %         onNeighborFocalChk=sum(sampNeighborFocalEdgeDist==0);
% %         if onNeighborFocalChk>0
% %             indOnNeighborFocal=find(sampNeighborFocalEdgeDist==0);
% %             cNeighborFocal(indOnNeighborFocal)=c(indNeighbor,1);
% %         end
% % 
% %         %Checking and denoting chemical contribution for CAFI in the chemical threshold
% %         %range
% %         deltaNeighborFocalChk=sum(sampNeighborFocalEdgeDist>=X0(1) & sampNeighborFocalEdgeDist<=Rstar(indNeighbor)-rNeighbor);
% %         if deltaNeighborFocalChk>0
% %             indDeltaNeighborFocal=find(sampNeighborFocalEdgeDist>=X0(1) & sampNeighborFocalEdgeDist<=Rstar(indNeighbor)-rNeighbor);
% %             indChemNeighborFocal=sum(sampNeighborFocalEdgeDist(indDeltaNeighborFocal)>=X0,2);
% %             cNeighborFocal(indDeltaNeighborFocal)=c(indNeighbor,indChemNeighborFocal);
% %         end
% % 
% %         %Weight this chemical contribution by travel distance to the edge of
% %         %our focal coral
% %         cNeighborFocalTravel=cNeighborFocal.*exp(-mu.*sampNeighborFocalEdgeDist);
% % 
% %         %Computing chemical contribution from neighbors
% %         if nNeighbors>0
% %             %Computing CAFI distances from neighboring corals
% %             sampFocalNeighborDist=sqrt((xSamps-xNeighborsFocal).^2+(ySamps-yNeighborsFocal).^2);
% % 
% %             %Distance from edges of neighbor corals
% %             sampFocalNeighborEdgeDist=sampFocalNeighborDist-R(indNeighbor);
% %             sampFocalNeighborEdgeDist(1,:)=sampFocalNeighborDist(1,:)-R(indFocal);
% %             %If in or on edge of coral, distance is 0
% %             sampFocalNeighborEdgeDist(sampFocalNeighborEdgeDist<X0(1))=0;
% % 
% %             %Compute chemical contribution from each neighbor
% %             cFocalNeighbor=zeros(nNeighbors,nSamps);
% %             for jj=1:nNeighbors
% %                 %Checking and denoting chemical for CAFI in or on edge of
% %                 %neighbor
% %                 onFocalNeighborChk=sum(sampNeighborEdgeDist(jj,:)==0);
% %                 if onFocalNeighborChk>0
% %                     indOnFocalNeighbor=find(sampFocalNeighborEdgeDist(jj,:)==0);
% %                     if jj==1
% %                       cFocalNeighbor(jj,indOnFocalNeighbor)=c(indfocal,1); 
% %                     else
% %                         cFocalNeighbor(jj,indOnFocalNeighbor)=c(indNeighbor,1);
% %                     end
% %                 end
% % 
% %                 %Checking and denoting chemical for CAFI in threshold range of
% %                 %neighboring coral
% %                 if jj==1
% %                     deltaFocalNeighborChk=sum(sampFocalNeighborEdgeDist(jj,:)>=X0(1) & ...
% %                     sampFocalNeighborEdge(jj,:)<=Rstar(indFocal)-R(indFocal));
% %                 else
% %                     deltaFocalNeighborChk=sum(sampFocalNeighborEdgeDist(jj,:)>=X0(1) & ...
% %                     sampFocalNeighborEdge(jj,:)<=Rstar(indNeighbor)-R(indNeighbor));
% %                 end
% % 
% %                 if deltaFocalNeighborChk>0
% %                     if jj==1
% %                         indDeltaFocalNeighbor=find(sampFocalNeighborEdgeDist(jj,:)>=X0(1) & ...
% %                             sampFocalNeighborEdge(jj,:)<=Rstar(indFocal)-R(indFocal));
% %                         indChemFocalNeighbor=sum(sampFocalNeighborEdgeDist(jj,indDeltaFocalNeighbor)>=X0,2);
% %                         cFocalNeighbor(jj,indDeltaFocalNeighbor)=c(indFocal,indChemFocalNeighbor);
% %                     else
% %                         indDeltaFocalNeighbor=find(sampFocalNeighborEdgeDist(jj,:)>=X0(1) & ...
% %                             sampFocalNeighborEdge(jj,:)<=Rstar(indNeighbor)-R(indNeighbor));
% %                         indChemFocalNeighbor=sum(sampFocalNeighborEdgeDist(jj,indDeltaFocalNeighbor)>=X0,2);
% %                         cFocalNeighbor(jj,indDeltaFocalNeighbor)=c(indNeighbor,indChemFocalNeighbor);
% %                     end
% % 
% %                 end
% %             end
% % 
% %             %Getting the total neighbor contribution at each point in the
% %             %samples 
% %             cFocalNeighbor=sum(cFocalNeighbor);
% %         else
% %             %No neighbors, hence chemical contribution is 0
% %             cFocalNeighbor=zeros(1,nSamps);
% %         end
% % 
% %         %Integrand
% %         FNeighbor=cNeighborFocalTravel./(cFocalNeighbor+cNeighborFocal);
% %         FNeighbor(isnan(FNeighbor))=0;
% %         %Estimate of Average number of settlers to focal coral
% %         lamBarNeighbor(j)=nNeighbors*(lam0*ANeighborFocal/(nSamps))*sum(FNeighbor);
% %     end
% % end
% % 
% % 
% % 
% % 
% % 
