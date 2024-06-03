% clc
% clear
% close all
% 
% set(groot,'DefaultAxesFontSize',20); set(gca,'FontSize',22);set(gca,'FontWeight','bold'); set(groot,'defaultLineLineWidth',2);
% 
% load('Coral_CAFI_time_series_data_rmax=500.mat')
% load('Coral_Growth_Mort_Imm_Parameters.mat','A_total')

phi_range=-0.9:0.1:0.9;
phi_range=round(phi_range,1);

nPhi=length(phi_range);

indVals=zeros(1,nPhi);
for j=1:nPhi
    indVals(j)=find(round(phi_g,1)==phi_range(j) & round(phi_L,1)==phi_range(j));
end

dr=rdata(2)-rdata(1);
nr=length(rdata);
ind1cm=find(round(rdata,1)==1);
rdata_mat=rdata(ind1cm:end);
nr_mat=length(rdata_mat);

totPop=zeros(2,nPhi);
totPop_mat=totPop;
avRad=zeros(2,nPhi);
avRad_mat=avRad;
Area=zeros(2,nPhi);
Area_mat=Area;
varRad=zeros(2,nPhi);
varRad_mat=zeros(2,nPhi);
indDisp=zeros(2,nPhi);
indDisp_mat=indDisp;

uSSHighD=zeros(1,nr);
uSSHighD_mat=zeros(1,nr_mat);

uSSLowD=zeros(1,nr);
uSSLowD_mat=zeros(1,nr_mat);

for jj=1:nPhi
    uSSHighD=HighDSizeDist(end,:,indVals(jj));
    uSSHighD_mat=uSSHighD(ind1cm:end);
    
    uSSLowD=LowDSizeDist(end,:,indVals(jj));
    uSSLowD_mat=uSSLowD(ind1cm:end);

    totPop(1,jj)=trap(uSSHighD,dr);
    totPop(2,jj)=trap(uSSLowD,dr);
    totPop_mat(1,jj)=trap(uSSHighD_mat,dr);
    totPop_mat(2,jj)=trap(uSSLowD_mat,dr);

    avRad(1,jj)=trap(rdata.*uSSHighD,dr)./totPop(1,jj);
    avRad(2,jj)=trap(rdata.*uSSLowD,dr)./totPop(2,jj);
    avRad_mat(1,jj)=trap(rdata_mat.*uSSHighD_mat,dr)./totPop_mat(1,jj);
    avRad_mat(2,jj)=trap(rdata_mat.*uSSLowD_mat,dr)./totPop_mat(2,jj);

    Area(1,jj)=trap(pi.*rdata.^2.*uSSHighD,dr);
    Area(2,jj)=trap(pi.*rdata.^2.*uSSLowD,dr);
    Area_mat(1,jj)=trap(pi.*rdata_mat.^2.*uSSHighD_mat,dr);
    Area_mat(2,jj)=trap(pi.*rdata_mat.^2.*uSSLowD_mat,dr);
    
    varRad(1,jj)=Area(1,jj)/(pi*totPop(1,jj))-(avRad(1,jj))^2;
    varRad(2,jj)=Area(2,jj)/(pi*totPop(2,jj))-(avRad(2,jj))^2;
    varRad_mat(1,jj)=Area_mat(1,jj)/(pi*totPop_mat(1,jj))-(avRad_mat(1,jj))^2;
    varRad_mat(2,jj)=Area_mat(2,jj)/(pi*totPop_mat(2,jj))-(avRad_mat(2,jj))^2;

    indDisp(1,jj)=varRad(1,jj)/avRad(1,jj);
    indDisp(2,jj)=varRad(2,jj)/avRad(2,jj);
    indDisp_mat(1,jj)=varRad_mat(1,jj)/avRad_mat(1,jj);
    indDisp_mat(2,jj)=varRad_mat(2,jj)/avRad_mat(2,jj);
end


perArea=100*Area/A_total;
perArea_mat=100*Area_mat/A_total;

% figure()
% plot(phi_range,varRad_mat,'LineWidth',3)
% xlabel('CAFI Effect')
% ylabel('Radius variance')
% legend('High immigration setting','Low immigration setting')

figure()
subplot(2,2,1)
plot(phi_range,totPop_mat)
xlabel('CAFI Effect')
ylabel('Corals')
title('Total Population')

subplot(2,2,2)
plot(phi_range,avRad_mat)
xlabel('CAFI Effect')
ylabel('Cm')
title('Average Radius')

subplot(2,2,3)
plot(phi_range,perArea_mat)
ylim([0,100])
xlabel('CAFI Effect')
ylabel('%')
title('Percent Area Occupied')

subplot(2,2,4)
plot(phi_range,indDisp_mat)
xlabel('CAFI Effect')
ylabel('\sigma^2/\mu')
title('Index of Dispersion')

sgtitle('Size Distribution Summary Features')



