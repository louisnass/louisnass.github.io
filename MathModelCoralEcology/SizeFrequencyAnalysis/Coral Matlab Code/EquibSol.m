%% Equilibrium Solution to IBVP
A=zeros(nPhi,1);
growth=zeros(nPhi,nr);
mort=zeros(nPhi,nr);
mortGrowth=zeros(nPhi,nr);
imm=zeros(nPhi,1);
expInt=zeros(nPhi,nr);
numSS=zeros(nPhi,nr);
for j=1:nPhi
    numSS(j,:)=HighDSizeDist(end,:,indPhi(j));
    numSStemp=numSS(j,:);
    A(j)=trap(pi.*rdata.^2.*numSStemp,dr);
    fs=round(1-A(j)/A_total,3);
    cafiHill=Hill(X(F==fs,:),phiGrowthSelect(j),rdata,beta_Hill,theta_Hill);
    growth(j,:)=gam(A(j),A_total,gamma,p_growth).*cafiHill;
    mort(j,:)=1./(life_expectancy(rdata,Lmin,Lmax,beta_mort,theta_mort).*cafiHill);
    mortGrowth(j,:)=mort(j,:)./growth(j,:);
    imm(j)=Gamma*(1-(A(j)/A_total).^p_imm);
    for jj=1:nr
        expInt(j,jj)=exp(-trap(mortGrowth(j,1:jj),dr));
    end
end

equibSols=(imm./growth).*expInt;

nMarkers=50;
lSpace=logspace(log10(rm),log10(rM),nMarkers);
markerIndices=zeros(50,1);
for jj=1:nMarkers
markerIndices(jj)=find(rdata<=lSpace(jj),1,'last');
end
% 
% figure()
% loglog(rdata,equibSols(1,:),'Color',[0.8500 0.3250 0.0980])
% hold on
% loglog(rdata,numSS(1,:),'*','MarkerIndices',markerIndices,'Color',[0.8500 0.3250 0.0980])
% hold on
% loglog(rdata,equibSols(2,:),'Color',[0.4940 0.1840 0.5560])
% hold on
% loglog(rdata,numSS(2,:),'*','MarkerIndices',markerIndices,'Color',[0.4940 0.1840 0.5560])
% hold on
% loglog(rdata,equibSols(3,:),'Color',[0 0.4470 0.7410])
% hold on
% loglog(rdata,numSS(3,:),'*','MarkerIndices',markerIndices,'Color',[0 0.4470 0.7410])
% 
% title('Equilibrium solutions and numerical steady-states')
% xlabel('Coral radius (cm)')
% ylabel('Coral frequency')
% ylim([10^-5,1000])
% xlim([rm,rM])

figure()
semilogx(rdata,mortGrowth(1,:),'Color',[0.8500 0.3250 0.0980])
hold on
semilogx(rdata,mortGrowth(2,:),'Color',[0.4940 0.1840 0.5560])
hold on
semilogx(rdata,mortGrowth(3,:),'Color',[0 0.4470 0.7410])
title('Mortality-growth ratio')
xlabel('Coral radius (cm)')
ylabel('\mu(r,A^*)/\gamma(r,A^*) (cm)')
legend('D CAFI', 'N CAFI', 'B CAFI')
xlim([rm,rM])




