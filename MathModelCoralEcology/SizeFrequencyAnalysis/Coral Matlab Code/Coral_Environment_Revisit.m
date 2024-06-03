%5 x 5 meter section of the sandbox 
m=5;
Asec=(m*100)^2;
%Comparing Beneficial, Neutral and Deleterious CAFI 
phiVals=[-0.5,0,0.5];
nPhi=length(phiVals);
indVals=zeros(1,nPhi);
%Picking out our densities from our library
for j=1:nPhi
    indVals(j)=find(phi_range==phiVals(j) & phi_range==phiVals(j));
end

%Picking our distributions that we want to sim
lamPoisHighD=zeros(nPhi,nr);
lamPoisLowD=zeros(nPhi,nr);
for j=1:nPhi
    lamPoisHighD(j,:)=uSSHighD(indVals(j),:)*dr;
    lamPoisLowD(j,:)=uSSLowD(indVals(j),:)*dr;
end

lamPoisHighD=lamPoisHighD(:,ind1cm:end);
lamPoisHighD(:,1)=lamPoisHighD(:,1)/2;lamPoisHighD(:,end)=lamPoisHighD(:,end)/2;
lamPoisLowD=lamPoisLowD(:,ind1cm:end);
lamPoisLowD(:,1)=lamPoisLowD(:,1)/2;lamPoisLowD(:,end)=lamPoisLowD(:,end)/2;

nCoralSampsHighD=poissrnd(lamPoisHighD);
nHighD=sum(nCoralSampsHighD,2);
nCoralSampsLowD=poissrnd(lamPoisLowD);
nLowD=sum(nCoralSampsLowD,2);

rSampsHighD=NaN(nPhi,max(nHighD));
for j=1:nPhi
    nonZerosInd=find(nCoralSampsHighD(j,:)>0);
    nNonZeros=length(nonZerosInd);
    indTemp=1;
    for k=1:nNonZeros
        nCorals=nCoralSampsHighD(j,nonZerosInd(k));
        rVals=rdata_mat(nonZerosInd(k))*ones(nCorals,1);
        rSampsHighD(j,indTemp:indTemp+nCorals-1)=rVals;
        indTemp=indTemp+nCorals;
    end
end

rSampsLowD=NaN(nPhi,max(nLowD));
for j=1:nPhi
    nonZerosInd=find(nCoralSampsLowD(j,:)>0);
    nNonZeros=length(nonZerosInd);
    indTemp=1;
    for k=1:nNonZeros
        nCorals=nCoralSampsLowD(j,nonZerosInd(k));
        rVals=rdata_mat(nonZerosInd(k))*ones(nCorals,1);
        rSampsLowD(j,indTemp:indTemp+nCorals-1)=rVals;
        indTemp=indTemp+nCorals;
    end
end

nSubSetHighD=round((Asec/A_total)*nHighD);
nSubSetLowD=round((Asec/A_total)*nLowD);

rSampsHighDSubSet=NaN(nPhi,max(nSubSetHighD));
rSampsLowDSubSet=NaN(nPhi,max(nSubSetLowD));

for j=1:nPhi
    rSampsHighDSubSet(j,1:nSubSetHighD(j))=datasample(rSampsHighD(j,1:nHighD(j)),nSubSetHighD(j));
    rSampsHighDSubSet(j,1:nSubSetHighD(j))=sort(rSampsHighDSubSet(j,1:nSubSetHighD(j)),'descend');
    rSampsLowDSubSet(j,1:nSubSetLowD(j))=datasample(rSampsLowD(j,1:nLowD(j)),nSubSetLowD(j));
    rSampsLowDSubSet(j,1:nSubSetLowD(j))=sort(rSampsLowDSubSet(j,1:nSubSetLowD(j)),'descend');
end

reDrawOverlap=0;
xValsHighD=NaN(nPhi,max(nSubSetHighD));
yValsHighD=NaN(nPhi,max(nSubSetHighD));

xValsLowD=NaN(nPhi,max(nSubSetLowD));
yValsLowD=NaN(nPhi,max(nSubSetLowD));
figure()
for j=1:nPhi
    check=1;
    while check<nSubSetHighD(j)+1
        locations=unifrnd(0,m*100,[2,1]);
        xValsHighD(j,check)=locations(1);yValsHighD(j,check)=locations(2);
        if check==1
            check=check+1;
        else
           dist=(xValsHighD(j,1:check-1)-xValsHighD(j,check)).^2+(yValsHighD(j,1:check-1)-yValsHighD(j,check)).^2;
           rSumsHighD=(rSampsHighDSubSet(j,1:check-1)+rSampsHighDSubSet(j,check)).^2;
           overlap=sum(dist<rSumsHighD);
           if overlap==0
               check=check+1;
           else
               reDrawOverlap=reDrawOverlap+1;
           end
        end
    end
    subplot(2,3,j)
    for jj=1:nSubSetHighD(j)
        coral=nsidedpoly(1000,'Center',[xValsHighD(j,jj)/100,yValsHighD(j,jj)/100],'Radius',rSampsHighDSubSet(j,jj)/100);
        hold on
        plot(coral, 'FaceColor',[0 0.4470 0.7410])
    end
    xlim([0,5])
    ylim([0,5])
    check=1;
    while check<nSubSetLowD(j)+1
        locations=unifrnd(0,m*100,[2,1]);
        xValsLowD(j,check)=locations(1);yValsLowD(j,check)=locations(2);
        if check==1
            check=check+1;
        else
           dist=(xValsLowD(j,1:check-1)-xValsLowD(j,check)).^2+(yValsLowD(j,1:check-1)-yValsLowD(j,check)).^2;
           rSumsLowD=(rSampsLowDSubSet(j,1:check-1)+rSampsLowDSubSet(j,check)).^2;
           overlap=sum(dist<rSumsLowD);
           if overlap==0
               check=check+1;
           else
               reDrawOverlap=reDrawOverlap+1;
           end
        end
    end
    subplot(2,3,nPhi+j)
    for jj=1:nSubSetLowD(j)
        coral=nsidedpoly(1000,'Center',[xValsLowD(j,jj)/100,yValsLowD(j,jj)/100],'Radius',rSampsLowDSubSet(j,jj)/100);
        hold on
        plot(coral, 'FaceColor',[0 0.4470 0.7410])
    end
    xlim([0,5])
    ylim([0,5])     
end 
