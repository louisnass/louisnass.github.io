% Here we will simulate environments and extract expected maximum

%We wish to do this to generate a figure similar to the summary stat
phi_range=round(-0.9:0.1:0.9,1);
nPhi=length(phi_range);
indVals=zeros(1,nPhi);
%Picking out our densities from our library
for j=1:nPhi
    indVals(j)=find(phi_g==phi_range(j) & phi_L==phi_range(j));
end

ind1cm=find(rdata==1);
rdata_mat=rdata(ind1cm:end);
nr_mat=length(rdata_mat);

uSSHighD=zeros(nPhi,nr);
uSSHighD_mat=zeros(nPhi,nr_mat);
uSSLowD=zeros(nPhi,nr);
uSSLowD_mat=zeros(nPhi,nr_mat);

for j=1:nPhi
    uSSHighD(j,:)=HighDSizeDist(end,:,indVals(j));
    uSSHighD_mat(j,:)=uSSHighD(j,ind1cm:end);
    
    uSSLowD(j,:)=LowDSizeDist(end,:,indVals(j));
    uSSLowD_mat(j,:)=uSSLowD(j,ind1cm:end);
end

totPopHighD=trap(uSSHighD,dr);
totPopLowD=trap(uSSLowD,dr);



%Poisson RV for each bin, using area from Trapezoidal rule
lamPoisHighD=uSSHighD*dr;
lamPoisHighD(:,1)=lamPoisHighD(:,1)/2;lamPoisHighD(:,end)=lamPoisHighD(:,end)/2;

lamPoisLowD=uSSLowD*dr;
lamPoisLowD(:,1)=lamPoisLowD(:,1)/2;lamPoisLowD(:,end)=lamPoisLowD(:,end)/2;

nSims=500;

simMaxHighD=zeros(nPhi,nSims);

simMaxLowD=zeros(nPhi,nSims);

NCoralsHighD=zeros(nPhi,nSims);
NCoralsLowD=NCoralsHighD;


for jj=1:nSims
    rSampsHighD=poissrnd(lamPoisHighD);
    rSampsLowD=poissrnd(lamPoisLowD);

    NCoralsHighD(:,jj)=sum(rSampsHighD,2);
    NCoralsLowD(:,jj)=sum(rSampsLowD,2);
    
    for k=1:nPhi
        if sum(rSampsHighD(k,:))==0
            simMaxHighD(k,jj)=0;
        else
            rMaxIndHighD=find(rSampsHighD(k,:)>0,1,'last');
            simMaxHighD(k,jj)=rdata_mat(rMaxIndHighD);
        end
        
        if sum(rSampsLowD(k,:))==0
            simMaxLowD(k,jj)=0;
        else
            rMaxIndLowD=find(rSampsLowD(k,:)>0,1,'last');
            simMaxLowD(k,jj)=rdata_mat(rMaxIndLowD);
        end
    end
     disp(['Simulated High and Low D ',num2str(jj), ' times'])
end

lNCoralsHighD=sum(log(NCoralsHighD),2)./nSims;
lNCoralsLowD=sum(log(NCoralsLowD),2)./nSims;

RmaxHighD=max(RMaxEstHigh+lNCoralsHighD-log(totPopHighD),0);
RmaxLowD=max(RMaxEstLow+lNCoralsLowD-log(totPopLowD),0);


    
avMaxRadHighD=mean(simMaxHighD,2);
sdMaxRadHighD=std(simMaxHighD,[],2);
errorHighD=1.96*sdMaxRadHighD/(sqrt(nSims));

avMaxRadLowD=mean(simMaxLowD,2);
sdMaxRadLowD=std(simMaxLowD,[],2);
errorLowD=1.96*sdMaxRadLowD/(sqrt(nSims));

figure()
subplot(1,2,1)
plot(phi_range,RmaxHighD)
hold on
errorbar(phi_range,avMaxRadHighD,errorHighD,'*','LineWidth',2)
xlabel('CAFI Effect')
ylabel('Largest Expected Coral Radius (cm)')
title('420 coral larva/month')

subplot(1,2,2)
 plot(phi_range,RmaxLowD)
hold on
errorbar(phi_range,avMaxRadLowD,errorLowD,'*','LineWidth',2)
xlabel('CAFI Effect')
ylabel('Largest Expected Coral Radius (cm)')
title('14 coral larva/month')

figure()
 plot(phi_range,RmaxHighD)
 hold on
errorbar(phi_range,avMaxRadHighD,errorHighD,'*','LineWidth',2)
hold on
plot(phi_range,RmaxLowD)
hold on
errorbar(phi_range,avMaxRadLowD,errorLowD,'*','LineWidth',2)
xlabel('CAFI Effect')
ylabel('Largest Expected Coral Radius (cm)')

