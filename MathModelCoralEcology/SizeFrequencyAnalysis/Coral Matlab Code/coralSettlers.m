%%Creating a funciton, given inputs of:
%- Coral locations
%- Coral radii
%- Chemical function c(x_0,R) tells you chemical exuding from a coral with
%radius R when a point is x_0 distance from the EDGE of the coral
%- If CAFI are cleared from 
%Outputs:
%- figure of layout
%Table containing:
%- coral locations and radii
%- lamBar(R) (Average CAFI settlement rate to a coral with radius R)
%- XBar(R) (Average CAFI density to each coral)

function [landscape,bubbleChart, coralCAFISettlementData]=coralSettlers(locations, radiusData, c, X0, RStar, mu,lam0, treatment,figs,treatments)

nCorals=length(radiusData);

dr=0.1;
rM=500;
rm=0.1;
R=round(rm:dr:rM,2);

radiusInd=zeros(nCorals,1);
for j=1:nCorals
    radiusInd(j)=find(radiusData(j)<=R,1,'First');
end

lamBar=zeros(nCorals,treatments);
XBar=lamBar;


nX0=length(X0);

nSamps=100000;

if nCorals==1
    disp('Only 1 coral!')
    
    lamBar=lam0*pi*radiusData^2+(2*pi*lam0/(mu^2))*(mu*radiusData+1-...
        (mu*RStar(R==radiusData)+1)*exp(-mu*(RStar(R==radiusData)-radiusData)));

    XBar=cafiData(lamBar/(pi*radiusData^2),treatment);

else

    for j=1:2%Adjust for which corals you want data from
        %Decide focal and neighbors
        focalLocation=locations(j,:);
        focalRadius=radiusData(j);
        focalRadiusInd=radiusInd(j);
        cFocal=c(focalRadiusInd,:);
        focalRStar=RStar(focalRadiusInd);
        AFocal=(2*focalRStar)^2;
    
        if j==1
            neighborLocations=locations(2:end,:);
            neighborRadii=radiusData(2:end);
            neighborRadiiInd=radiusInd(2:end);
        elseif j==nCorals
            neighborLocations=locations(1:end-1,:);
            neighborRadii=radiusData(1:end-1);
            neighborRadiiInd=radiusInd(1:end-1);
        elseif j==2
            neighborLocations=[locations(3:end,:);locations(1,:)];
            neighborRadii=[radiusData(3:end);radiusData(1)];
            neighborRadiiInd=[radiusInd(3:end);radiusInd(1)];
        % else
        %     neighborLocations=[locations(1:j-1,:);locations(j+1:end,:)];
        %     neighborRadii=[radiusData(1:j-1);radiusData(j+1:end)];
        %     neighborRadiiInd=[radiusInd(1:j-1);radiusInd(j+1:end)];
        end
        
        cNeighbor=zeros(nCorals-1,nX0-1);
        neighborRStar=zeros(nCorals-1,1);
        for jj=1:nCorals-1
            cNeighbor(jj,:)=c(neighborRadiiInd(jj),:);
            neighborRStar(jj)=RStar(neighborRadiiInd(jj));
        end
    
        focalSamps=unifrnd(-focalRStar,focalRStar,2,nSamps)+focalLocation';
    
        sampFocalDist=sqrt((focalSamps(1,:)-focalLocation(1)).^2+(focalSamps(2,:)-focalLocation(2)).^2);
        sampFocalEdgeDist=sampFocalDist-focalRadius;
        sampFocalEdgeDist(sampFocalDist<X0(1))=0;
        
        cFocalSamps=zeros(1,nSamps);
    
        disp(['Identifying chemical for samples on ',num2str(j),'-th coral out of ',num2str(nCorals),' corals' ])
    
        onFocalChk=sum(sampFocalEdgeDist==0);
        if onFocalChk>0
            cFocalSamps(sampFocalEdgeDist==0)=cFocal(1);
        end
    
        disp(['Identifying chemical for samples in threshold annulus of ',num2str(j),'-th coral out of ',num2str(nCorals),' corals' ])
        %Checking and denoting chemical contribution for CAFI in the chemical threshold
        %range
        deltaFocalChk=sum(sampFocalEdgeDist>=X0(1) & sampFocalEdgeDist<=focalRStar-focalRadius);
        if deltaFocalChk>0
            indDeltaFocal=find(sampFocalEdgeDist>=X0(1) & sampFocalEdgeDist<=focalRStar-focalRadius);
            indChemFocal=sum(sampFocalEdgeDist(indDeltaFocal)'>=X0,2);
            cFocalSamps(indDeltaFocal)=cFocal(indChemFocal);
        end
    
        %Weight this chemical contribution by travel distance to the edge of
        %our focal coral
        disp(['Computing chemical weighted by distance from ',num2str(j),'-th coral edge out of ',num2str(nCorals),' corals' ])
        cFocalTravel=cFocalSamps.*exp(-mu.*sampFocalEdgeDist);
    
        %Computing CAFI distances from neighboring corals
        sampNeighborDist=sqrt((focalSamps(1,:)-neighborLocations(:,1)).^2+(focalSamps(2,:)-neighborLocations(:,2)).^2);
    
        sampNeighborEdgeDist=sampNeighborDist-neighborRadii;
    
        sampNeighborEdgeDist(sampNeighborEdgeDist<X0(1))=0;
    
        %Compute chemical contribution from each neighbor
        cNeighborSamps=zeros(nCorals-1,nSamps);
        for jj=1:nCorals-1
            disp(['Identifying chemical contribution from neighbor ',num2str(jj),' out of ',num2str(nCorals-1),' corals'])
            %Checking and denoting chemical for CAFI in or on edge of
            %neighbor
            onNeighborChk=sum(sampNeighborEdgeDist(jj,:)==0);
            if onNeighborChk>0
                cNeighborSamps(jj,sampNeighborEdgeDist(jj,:)==0)=cNeighbor(jj,1);
            end
    
            %Checking and denoting chemical for CAFI in threshold range of
            %neighboring coral
            deltaNeighborChk=sum(sampNeighborEdgeDist(jj,:)>=X0(1) & ...
                    sampNeighborEdgeDist(jj,:)<=neighborRStar(jj)-neighborRadii(jj));
    
            if deltaNeighborChk>0
                indDeltaNeighbor=find(sampNeighborEdgeDist(jj,:)>=X0(1) & ...
                    sampNeighborEdgeDist(jj,:)<=neighborRStar(jj)-neighborRadii(jj));
                indChemNeighbor=sum(sampNeighborEdgeDist(jj,indDeltaNeighbor)'>=X0,2);
                cNeighborSamps(jj,indDeltaNeighbor)=cNeighbor(jj,indChemNeighbor);
            end
    
        end
    
        cNeighborSampsSum=sum(cNeighborSamps,1);
        
        %Integrand 
        %Corals can steal if CAFI land on coral
        F=cFocalTravel./(cFocalSamps+cNeighborSampsSum);
        F(isnan(F))=0;

         %Estimate of Average number of settlers to focal coral
        lamBar(j,1)=(lam0*AFocal/(nSamps))*sum(F);
        XBar(j,1)=cafiData(lamBar(j,1)/(pi*focalRadius^2),treatment(j));

        %CAFI always settle if they land on corals
        FF=F;
        %%Landing on a coral guarantees succesful settlment
        FF(sampFocalEdgeDist==0)=1;
        for jj=1:nCorals-1
            FF(sampNeighborEdgeDist(jj,:)==0)=0;
        end
        lamBar(j,2)=(lam0*AFocal/(nSamps))*sum(FF);
        XBar(j,2)=cafiData(lamBar(j,2)/(pi*focalRadius^2),treatment(j));

        %CAFI Settle to largest coral
        FFF=ones(1,length(F));
        FFF(sampFocalEdgeDist>focalRStar-focalRadius)=0;
        for jj=1:nCorals-1
            if focalRadius==neighborRadii(jj)
                FFF(sampNeighborEdgeDist(jj,:)<=neighborRStar(jj)-neighborRadii(jj) &...
                    sampNeighborEdgeDist(jj,:)<sampFocalEdgeDist)=0;
                FFF(sampFocalEdgeDist<=focalRStar-focalRadius & ...
                    sampNeighborEdgeDist(jj,:)<=neighborRStar(jj)-neighborRadii(jj) & ...
                    sampNeighborEdgeDist(jj,:)==sampFocalEdgeDist)=1/2;
            elseif focalRadius<neighborRadii(jj)
                FFF(sampNeighborEdgeDist(jj,:)<=neighborRStar(jj)-neighborRadii(jj))=0;
            end
        end
        FFF=FFF.*exp(-mu.*sampFocalEdgeDist);
        lamBar(j,3)=(lam0*AFocal/(nSamps))*sum(FFF);
        XBar(j,3)=cafiData(lamBar(j,3)/(pi*focalRadius^2),treatment(j));
        
        %CAFI Settle to closest coral
        FFFF=ones(1,length(F));
        FFFF(sampFocalEdgeDist>focalRStar-focalRadius)=0;
        for jj=1:nCorals-1
            FFFF(sampNeighborEdgeDist(jj,:)< sampFocalEdgeDist) = 0;
            FFFF(sampFocalEdgeDist<=focalRStar-focalRadius & ...
                sampNeighborEdgeDist(jj,:)<=neighborRStar(jj)-neighborRadii(jj) & ...
                sampFocalEdgeDist==sampNeighborEdgeDist(jj,:))=1/2;
            for kk=1:nCorals-1
                if kk ~= jj
                    FFFF(sampFocalEdgeDist<=focalRStar-focalRadius & ...
                        sampNeighborEdgeDist(jj,:)<=neighborRStar(jj)-neighborRadii(jj) &...
                        sampNeighborEdgeDist(kk,:)<=neighborRStar(kk)-neighborRadii(kk) & ...
                        sampFocalEdgeDist == sampNeighborEdgeDist(jj,:) & ...
                        sampFocalEdgeDist == sampNeighborEdgeDist(kk,:))=1/3;
                end
            end
        end
        FFFF=FFFF.*exp(-mu.*sampFocalEdgeDist);
        lamBar(j,4)=(lam0*AFocal/(nSamps))*sum(FFFF);
        XBar(j,4)=cafiData(lamBar(j,4)/(pi*focalRadius^2),treatment(j));
        
    end
end

coralCAFISettlementData=table(locations,radiusData,lamBar,XBar);

if figs==1
    landscape=figure;
    for j=1:nCorals
        coral=nsidedpoly(1000,'Center',[locations(j,1),locations(j,2)],'Radius',radiusData(j));
        hold on
        plot(coral, 'FaceColor',[0 0.4470 0.7410])
    end
    % xlim([0,max(locations,[],'all')])
    % ylim([0,max(locations,[],'all')])
    axis square
    
    bubbleChart=figure;
    bubbleSizes1=coralCAFISettlementData.lamBar;
    bubbleSizes2=coralCAFISettlementData.XBar;
    bubblechart(locations(:,1),locations(:,2),bubbleSizes1,'MarkerFaceColor','b');
    hold on
    bubblechart(locations(:,1),locations(:,2),bubbleSizes2,'MarkerFaceColor','r');
    axis square
else
    landscape=1;
    bubbleChart=1;
end


end
