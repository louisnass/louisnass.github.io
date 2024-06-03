%%Generate landscapes that reflect the experiments done by Craig
lam0=10^(-5);
mu=0.004;

% %Experiment 1: Maatea
% %I am not sure what branching vs tight is so we will do 3 rows by 15
% %columns
% radiusMin=2.5;
% radiusMax=25;
% 
% %Differentiate emptied vs not-emptied CAFI
% nRows=2;
% nCols=15;
% totalCorals=nRows*nCols;
% 
% 
% dRadius=(radiusMax-radiusMin)/(nCols-1);
% radiusValues=(radiusMin:dRadius:radiusMax)';
% 
% dCenters=500;
% 
% locations=zeros(totalCorals,2);
% radiusData=zeros(totalCorals,1);
% treatment=[repmat('N',nCols,1);repmat('E',nCols,1)];
% 
% for j=1:nRows
%     locations((j-1)*nCols+1:j*nCols,1)=(0:dCenters:(nCols-1)*dCenters)';
%     locations((j-1)*nCols+1:j*nCols,2)=(j-1)*dCenters;
% 
%     radiusData((j-1)*nCols+1:j*nCols)=radiusValues;
% end
%  [MaateaLandscape, MaateaBubbleChart, MaateaSettlementData]=coralSettlers(locations,radiusData,c,X0,Rstar,mu,lam0,treatment);
% 
% %%Experiment 2 MRB
% nRows=3;
% nCols=9;
% 
% dCenters=500;
% 
% nHighReplicates=1;
% nCoralsHighReplicates=6;
% 
% nMediumReplicates=2;
% nCoralsMediumReplicates=3;
% 
% nSmallReplicates=6;
% nCoralsSmallReplicates=1;
% 
% totalCoralsRow=(nSmallReplicates*nCoralsSmallReplicates+...
%     nMediumReplicates*nCoralsMediumReplicates+nHighReplicates*nCoralsHighReplicates);
% 
% locations=zeros(totalCoralsRow*nRows,2);
% 
% radiusSz=11;
% radiusData=radiusSz*ones(totalCoralsRow*nRows,1);
% 
% treatment=repmat('N',totalCoralsRow*nRows);
% 
% 
% %1st row: S S S S S S M M H
% %Small replicate placement
% locations(1:nCoralsSmallReplicates*nSmallReplicates,1)=0:...
%     dCenters:dCenters*(nCoralsSmallReplicates*nSmallReplicates-1);
% %Medium replicate placement
% centers=dCenters*(nCoralsSmallReplicates*nSmallReplicates):...
%     dCenters:dCenters*(nCoralsSmallReplicates*nSmallReplicates+nCoralsMediumReplicates*nMediumReplicates-1);
% for j=1:nMediumReplicates
%     locations((j-1)*nCoralsMediumReplicates+nCoralsSmallReplicates*nSmallReplicates+1:...
%         j*nCoralsMediumReplicates+nCoralsSmallReplicates*nSmallReplicates,:)=...
%         ReplicateLocations([centers(j),0],nCoralsMediumReplicates);
% end
% %High replicate placement
% center=(nCols-1)*dCenters;
% 
% locations(nCoralsMediumReplicates*nMediumReplicates+nCoralsSmallReplicates*nSmallReplicates+1:...
%     nCoralsHighReplicates+nCoralsMediumReplicates*nMediumReplicates+...
%     nCoralsSmallReplicates*nSmallReplicates,:)=ReplicateLocations([center,0],nCoralsHighReplicates);
% 
% %2nd Row S S S M H M S S S
% %2ndRow indicies
% Row2Indx=totalCoralsRow+1:2*totalCoralsRow;
% %Up a row
% locations(Row2Indx,2)=dCenters;
% 
% %S S S
% locations(Row2Indx(1:3),1)=0:dCenters:2*dCenters;
% 
% % M
% centers=3*dCenters;
% locations(Row2Indx(4:6),:)=ReplicateLocations([centers,dCenters],nCoralsMediumReplicates);
% 
% %H
% centers=4*dCenters;
% locations(Row2Indx(7:12),:)=ReplicateLocations([centers,dCenters],nCoralsHighReplicates);
% 
% %M
% centers=5*dCenters;
% locations(Row2Indx(13:15),:)=ReplicateLocations([centers,dCenters],nCoralsMediumReplicates);
% 
% %S S S
% locations(Row2Indx(16:end),1)=6*dCenters:dCenters:8*dCenters;
% 
% %%3rd Row M S S S H S S S M
% Row3Indx=2*totalCoralsRow+1:3*totalCoralsRow;
% locations(Row3Indx,2)=2*dCenters;
% %M
% locations(Row3Indx(1:3),:)=ReplicateLocations([0,2*dCenters],nCoralsMediumReplicates);
% 
% % S S S
% locations(Row3Indx(4:6),1)=(dCenters:dCenters:3*dCenters)';
% 
% %H
% centers=4*dCenters;
% locations(Row3Indx(7:12),:)=ReplicateLocations([centers,2*dCenters],nCoralsHighReplicates);
% 
% % S S S
% locations(Row3Indx(13:15),1)=(5*dCenters:dCenters:7*dCenters)';
% 
% %M
% centers=8*dCenters;
% locations(Row3Indx(16:end),:)=ReplicateLocations([centers,2*dCenters], nCoralsMediumReplicates);
% 
% 
% [MRBLandscape, MRBBubbleChart, MRBSettlementData]=coralSettlers(locations,radiusData,c,X0,Rstar,mu,lam0,treatment);
% 

%% Circle Experiment
% Here we will establish a circle of corals with a center coral and vary
% the distance between the center and edge we will go with 10 corals around
% the center
rCenter=8.5;
rCircle=round(rCenter/2,1);

RStarCent=Rstar(R==rCenter);
RStarCirc=Rstar(R==rCircle);

nCircle=9;

radiusData=rCircle*ones(nCircle+1,1);
radiusData(1)=rCenter;
radiusData(2:end)=rCircle;

dEdgeDistances=5;
edgeDistances=rCenter+rCircle:dEdgeDistances:RStarCent+RStarCirc+rCenter+rCircle+800;

%number of different 'scenarios' (Auto land, 'steal from neighbors', always
%largest, always closest
treatments=4;

nExperiments=length(edgeDistances);
lamBarCent=zeros(nExperiments,treatments);
XBarCent=zeros(nExperiments,treatments);

lamBarCirc=zeros(nExperiments,treatments);
XBarCirc=zeros(nExperiments,treatments);

treatment=repmat('N',nCircle+1,1);

expInd=find(edgeDistances>=50,1,'first');


for j=1:nExperiments
    if j==expInd
        figs=1;
    else
        figs=0;
    end

    locations=zeros(nCircle+1,2);


    dtheta=2*pi/(nCircle);
    theta=0:dtheta:2*pi-dtheta;

    locations(2:end,1)=edgeDistances(j)*cos(theta)';
    locations(2:end,2)=edgeDistances(j)*sin(theta)';


    [landscape,bubble,settlementData]=coralSettlers(locations,radiusData,c,X0,Rstar,mu,lam0,treatment,figs,treatments);
    if figs==1
        landscapeKeep=landscape;
        bubbleKeep=bubble;
    end

    lamBarCent(j,:)=settlementData.lamBar(1,:);
    lamBarCirc(j,:)=settlementData.lamBar(2,:);

    XBarCent(j,:)=settlementData.XBar(1,:);
    XBarCirc(j,:)=settlementData.XBar(2,:);

end

lamBarDensityCent=lamBarCent./(pi*rCenter^2);
lamBarDenstiyCirc=lamBarCirc./(pi*rCircle^2);

edgeDistances=edgeDistances-rCircle-rCenter;
 save('Coral_CAFI_10Corals2cmCircle',"rCenter","rCircle","nCircle","edgeDistances","lamBarCent","lamBarCirc","XBarCent","XBarCirc")

 figure()
 for j=1:4
    subplot(2,2,j)
    plot(edgeDistances,XBarCent(:,j))
    hold on
    plot(edgeDistances,XBarCirc(:,j))
    xlabel('\textbf{Edge distances (cm)}','Interpreter','latex')
    ylabel('$\mathbf{\bar{X}(r)}$','Interpreter','latex')
    if j==1
        title('\textbf{Stealing allowed}','Interpreter','latex')
    elseif j==2
        title('\textbf{Stealing not allowed}','Interpreter','latex')
        legend('Center coral r=8.5 cm','Circle coral r=4.24 cm')
    elseif j==3
        title('\textbf{To largest}','Interpreter','latex')
    else
        title('\textbf{To closest}','Interpreter','latex')
    end
    xlim([0,1700])
    ylim([0,0.06])
 end

 figure()
 for j=1:4
    subplot(2,2,j)
    plot(edgeDistances,lamBarCent(:,j))
    hold on
    plot(edgeDistances,lamBarCirc(:,j))
    xlabel('\textbf{Edge distances (cm)}','Interpreter','latex')
    ylabel('$\mathbf{\bar{\lambda}(r)}$','Interpreter','latex')
    if j==1
        title('\textbf{Stealing allowed}','Interpreter','latex')
    elseif j==2
        title('\textbf{Stealing not allowed}','Interpreter','latex')
        legend('Center coral r=8.5 cm','Circle coral r=4.25 cm')
    elseif j==3
        title('\textbf{To largest}','Interpreter','latex')
    else
        title('\textbf{To closest}','Interpreter','latex')
    end
    xlim([0,1700])
   
end


%% Same Habitat area, various configurations
%I am going to do 3 experiments 1 30 cm coral, 2 15 cm coral, 3 10 cm, 4
%7.5 cm corals corals and consider the effect of different layouts
% rValues=zeros(4,1);
% rValues(1)=10;
% for j=2:4
%     rValues(j)=round(sqrt(rValues(1)^2/j),1);
% end
% nCorals=[1;2;3;4];
% 
% 
% rStarVals=[Rstar(R==rValues(1));Rstar(R==rValues(2));Rstar(R==rValues(3));Rstar(R==rValues(4))];
% 
% dEdgeDistances=2;
% edgeDistances=0:dEdgeDistances:2*max(rStarVals);
% nExperiments=length(edgeDistances);
% 
% lamBar=zeros(5,nExperiments);
% XBar=lamBar;
% 
% %Setting 1
% locations=[0,0];
% treatment=repmat('N',nCorals(1),1);
% [landscape,bubble,settlementData]=coralSettlers(locations,rValues(1),c,X0,Rstar,mu,lam0,treatment);
% lamBar(1,:)=settlementData.lamBar*ones(1,nExperiments);
% XBar(1,:)=settlementData.XBar*ones(1,nExperiments);
% 
% for j=2:4
%     for jj=1:nExperiments
%         if j==2
%             locations=zeros(nCorals(j),2);
%             locations(2,1)=2*rValues(j)+edgeDistances(jj);
%             treatment=repmat('N',nCorals(j),1);
% 
%             [landscape,bubble,settlementData]=coralSettlers(locations,rValues(j)*ones(nCorals(j),1),c,X0,Rstar,mu,lam0,treatment);
%             lamBar(j,jj)=settlementData.lamBar(1);
%             XBar(j,jj)=settlementData.XBar(1);
%         elseif j==3
%             locations=zeros(nCorals(j),2);
%             locations(2,1)=2*rValues(j)+edgeDistances(jj);
%             locations(3,1)=(2*rValues(j)+edgeDistances(jj))/2;
%             locations(3,2)=sqrt(3)*(2*rValues(j)+edgeDistances(jj))/2;
%             treatment=repmat('N',nCorals(j),1);
% 
%             [landscape,bubble,settlementData]=coralSettlers(locations,rValues(j)*ones(nCorals(j),1),c,X0,Rstar,mu,lam0,treatment);
%             lamBar(j,jj)=settlementData.lamBar(1);
%             XBar(j,jj)=settlementData.XBar(1);
%         else
%             locations=zeros(nCorals(j),2);
%             locations(2,:)=2*rValues(j)+edgeDistances(jj);
%             locations(3,2)=2*rValues(j)+edgeDistances(jj);
%             locations(4,1)=2*rValues(j)+edgeDistances(jj);
%             treatment=repmat('N',nCorals(j),1);
% 
%             [landscape,bubble,settlementData]=coralSettlers(locations,rValues(j)*ones(nCorals(j),1),c,X0,Rstar,mu,lam0,treatment);
%             lamBar(j,jj)=settlementData.lamBar(1);
%             lamBar(j+1,jj)=settlementData.lamBar(2);
% 
%             XBar(j,jj)=settlementData.XBar(1);
%             XBar(j+1,jj)=settlementData.XBar(2);
%         end
%     end
% end

% function locationsReplicate=ReplicateLocations(center,nCorals)
%     dSepReplicate=50;
%     locationsReplicate=zeros(nCorals,2);
%     if nCorals>3
%         dtheta=2*pi/(nCorals-1);
%         theta=0:dtheta:2*pi-dtheta;
% 
%         locationsReplicate(1,:)=center;
%         locationsReplicate(2:end,1)=dSepReplicate.*cos(theta)'+center(1);
%         locationsReplicate(2:end,2)=dSepReplicate.*sin(theta)'+center(2);
%     else
%         dSepReplicate=dSepReplicate/2;
%         dtheta=2*pi/nCorals;
%         theta=0:dtheta:2*pi-dtheta;
% 
%         locationsReplicate(:,1)=dSepReplicate.*cos(theta)'+center(1);
%         locationsReplicate(:,2)=dSepReplicate.*sin(theta)'+center(2);
%     end
% end
 




