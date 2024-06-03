%Time Series Data Visualization

%choose CAFI level
% 
% phiGrowthSelect=[-0.5,0,0.5];
% phiLifeExpSelect=phiGrowthSelect;
% 
% nPhi=length(phiLifeExpSelect);%nphi;%length(phiLifeExpSelect);
% indPhi=zeros(nPhi,1);
% for j=1:nPhi
%     indPhi(j)=find(phi_g==phiGrowthSelect(j) & phi_L==phiLifeExpSelect(j));
% end

nPhi=nphi;
timeSeriesPopHighD=zeros(nPhi,length(tdataYr));
timeSeriesPop1cmHighD=zeros(nPhi,length(tdataYr));

% % timeSeriesPopLowD=zeros(nPhi,length(tdataYr));
% timeSeriesPop1cmLowD=zeros(nPhi,length(tdataYr));

timeSeriesAvgRadHighD=zeros(nPhi,length(tdataYr));
timeSeriesAvgRad1cmHighD=zeros(nPhi,length(tdataYr));

% timeSeriesAvgRadLowD=zeros(nPhi,length(tdataYr));
% timeSeriesAvgRad1cmLowD=zeros(nPhi,length(tdataYr));

timeSeriesPerAreaHighD=zeros(nPhi,length(tdataYr));
timeSeriesPerArea1cmHighD=zeros(nPhi,length(tdataYr));

% timeSeriesPerAreaLowD=zeros(nPhi,length(tdataYr));
% timeSeriesPerArea1cmLowD=zeros(nPhi,length(tdataYr));

for k=1:nPhi
    for jj=1:length(tdataYr)
        uSizeDistHighD=uSS(jj,:,k);%HighDSizeDist(jj,:,indPhi(k));
        
        timeSeriesPopHighD(k,jj)=trap(uSizeDistHighD,dr);
        timeSeriesPop1cmHighD(k,jj)=trap(uSizeDistHighD(ind1cm:end),dr);
        
        timeSeriesAvgRadHighD(k,jj)=trap(rdata.*uSizeDistHighD,dr)./timeSeriesPopHighD(k,jj);
        timeSeriesAvgRad1cmHighD(k,jj)=trap(rdata(ind1cm:end).*uSizeDistHighD(ind1cm:end),dr)./timeSeriesPop1cmHighD(k,jj);
        
        timeSeriesPerAreaHighD(k,jj)=100*trap(pi.*rdata.^2.*uSizeDistHighD,dr)/A_total;
        timeSeriesPerArea1cmHighD(k,jj)=100*trap(pi.*rdata(ind1cm:end).^2.*uSizeDistHighD(ind1cm:end),dr)/A_total;
        
        
        % uSizeDistLowD=LowDSizeDist2(jj,:,k);
        % 
        % timeSeriesPopLowD(k,jj)=trap(uSizeDistLowD,dr);
        % timeSeriesPop1cmLowD(k,jj)=trap(uSizeDistLowD(ind1cm:end),dr);
        % 
        % timeSeriesAvgRadLowD(k,jj)=trap(rdata.*uSizeDistLowD,dr)./timeSeriesPopLowD(k,jj);
        % timeSeriesAvgRad1cmLowD(k,jj)=trap(rdata(ind1cm:end).*uSizeDistLowD(ind1cm:end),dr)./timeSeriesPop1cmLowD(k,jj);
        % 
        % timeSeriesPerAreaLowD(k,jj)=100*trap(pi.*rdata.^2.*uSizeDistLowD,dr)/A_total;
        % timeSeriesPerArea1cmLowD(k,jj)=100*trap(pi.*rdata(ind1cm:end).^2.*uSizeDistLowD(ind1cm:end),dr)/A_total;
       disp(['Time series data for year =',num2str(tdataYr(jj))]); 
    end
end
timeSeriesAvgRadHighD(isnan(timeSeriesAvgRadHighD))=0;

tSPopB=timeSeriesPopHighD;
tSAvgRadB=timeSeriesAvgRadHighD;
tSAOccB=timeSeriesPerAreaHighD;

% figure()
% plot(tSPopB(2:end,:)',tSAvgRadB(2:end,:)','Color',Ncolor)
% hold on
% plot(tSPopB(1,:)',tSAvgRadB(1,:),'*','MarkerSize',20,'Color',Ncolor)
% hold on
% for j=2:nPhi
%     plot(tSPopB(j,1),tSAvgRadB(j,1),'o','MarkerSize',10,'Color',Ncolor)
%     hold on
% end
% xlabel('P(t)')
% ylabel('L(t)')
% title('Fixed A*(t)')
% 
% figure()
% plot(tSPopB(2:end,:)',tSAOccB(2:end,:)','Color',Ncolor)
% hold on
% plot(tSPopB(1,:)',tSAOccB(1,:),'*','MarkerSize',20,'Color',Ncolor)
% hold on
% for j=2:nPhi
%     plot(tSPopB(j,1),tSAOccB(j,1),'o','MarkerSize',10,'Color',Ncolor)
%     hold on
% end
% xlabel('P(t)')
% ylabel('A(t)')
% title('Fixed L*(t)')
% 
% figure()
% plot(tSAvgRadB(2:end,:)',tSAOccB(2:end,:)','Color',Ncolor)
% hold on
% plot(tSAvgRadB(1,:)',tSAOccB(1,:),'*','MarkerSize',20,'Color',Ncolor)
% hold on
% for j=2:nPhi
%     plot(tSAvgRadB(j,1),tSAOccB(j,1),'o','MarkerSize',10,'Color',Ncolor)
%     hold on
% end
% xlabel('L(t)')
% ylabel('A(t)')
% title('Fixed P*(t)')


% figure()
% plot(tdataYr,timeSeriesPopHighD(1,:),'Color',Dcolor)
% hold on
% plot(tdataYr,timeSeriesPopHighD(2,:),'--','Color',Dcolor)%'Color',[0.4940 0.1840 0.5560])%
% hold on
% plot(tdataYr,timeSeriesPopHighD(3,:),'-.','Color',Dcolor)%'Color',[0 0.4470 0.7410])%
% hold on
% plot(tdataYr,timeSeriesPopHighD(4,:),':','Color',Dcolor)%'Color',[0 0.4470 0.7410])%
% ylabel('Corals')
% xlabel('Years')
%  xlim([0,350])
% title('Total population')
% 
% figure()
% plot(tdataYr,timeSeriesAvgRadHighD(1,:),'Color',Dcolor)
% hold on
% plot(tdataYr,timeSeriesAvgRadHighD(2,:),'--','Color',Dcolor)%'Color',[0.4940 0.1840 0.5560])%
% hold on
% plot(tdataYr,timeSeriesAvgRadHighD(3,:),'-.','Color',Dcolor)%'Color',[0 0.4470 0.7410])%
% hold on
% plot(tdataYr,timeSeriesAvgRadHighD(4,:),':','Color',Dcolor)%'Color',[0 0.4470 0.7410])%
% ylabel('Average radius (cm)')
% xlabel('Years')
%  xlim([0,350])
%  title('Average radius')
% 
% figure()
% plot(tdataYr,timeSeriesPerAreaHighD(1,:),'Color',Dcolor)
% hold on
% plot(tdataYr,timeSeriesPerAreaHighD(2,:),'--','Color',Dcolor)%'Color',[0.4940 0.1840 0.5560])%
% hold on
% plot(tdataYr,timeSeriesPerAreaHighD(3,:),'-.','Color',Dcolor)%,'Color',[0 0.4470 0.7410])%
% hold on
% plot(tdataYr,timeSeriesPerAreaHighD(4,:),':','Color',Dcolor)%,'Color',[0 0.4470 0.7410])%
% ylabel('%')
% xlabel('Years')
%  xlim([0,350])
% title('Percent area occupied')
% ylim([0,100])
% legend('0 % start', '83 % start', '42 % start')

% figure()
% plot(tdataYr,timeSeriesPopHighD(1,:),'Color',[0.8500 0.3250 0.0980])
% hold on
% plot(tdataYr,timeSeriesPopHighD(2,:),'Color',[0.4940 0.1840 0.5560])%
% hold on
% plot(tdataYr,timeSeriesPopHighD(3,:),'Color',[0 0.4470 0.7410])%
% ylabel('Corals')
% xlabel('Years')
%  xlim([0,350])
% title('Total population')
% 
% figure()
% plot(tdataYr,timeSeriesAvgRadHighD(1,:),'Color',[0.8500 0.3250 0.0980])
% hold on
% plot(tdataYr,timeSeriesAvgRadHighD(2,:),'Color',[0.4940 0.1840 0.5560])%
% hold on
% plot(tdataYr,timeSeriesAvgRadHighD(3,:),'Color',[0 0.4470 0.7410])%
% ylabel('Average radius (cm)')
% xlabel('Years')
%  xlim([0,350])
%  title('Average radius')
% 
% figure()
% plot(tdataYr,timeSeriesPerAreaHighD(1,:),'Color',[0.8500 0.3250 0.0980])
% hold on
% plot(tdataYr,timeSeriesPerAreaHighD(2,:),'Color',[0.4940 0.1840 0.5560])%
% hold on
% plot(tdataYr,timeSeriesPerAreaHighD(3,:),'Color',[0 0.4470 0.7410])%
% ylabel('%')
% xlabel('Years')
%  xlim([0,350])
% title('Percent area occupied')
% ylim([0,100])
% 
% sgtitle('Numerical steady-state convergence')

%  figure()
%  for j=1:nphi
%     plot3(timeSeriesPopHighD(j,:),timeSeriesAvgRadHighD(j,:),timeSeriesPerAreaHighD(j,:))
%     hold on
%  end
% xlabel('Total pop.')
% ylabel('Avg. radius (cm)')
% zlabel('% area occ.')
% title('Time series data of distaster scenarios')
% zlim([0,100])

% % 
% figure()
% subplot(1,3,1)
% plot(tdataYr(1:end),timeSeriesPop1cmLowD(17:end,1:end))
% ylabel('Corals')
% xlabel('Years')
% xlim([0,450])
% title('Total population')
% 
% subplot(1,3,2)
% plot(tdataYr(1:end),timeSeriesAvgRad1cmLowD(17:end,1:end))
% ylabel('Average radius (cm)')
% xlabel('Years')
% xlim([0,450])
% title('Average radius')
% 
% subplot(1,3,3)
% plot(tdataYr(1:end),timeSeriesPerAreaLowD(17:end,1:end))
% ylabel('%')
% xlabel('Years')
% xlim([0,450])
% title('Percent area occupied')
% ylim([0,100])
% 
%  sgtitle('Low immigration system')

% 
% % figure()
% % subplot(2,2,1)
% % plot(tdataYr,timeSeriesPop1cmHighD)
% % hold on
% % plot(tdataYr,timeSeriesPop1cmLowD)
% % ylabel('Corals')
% % xlabel('Years')
% % xlim([0,450])
% % title('Total Population Over Time')
% % 
% % subplot(2,2,2)
% % plot(tdataYr,timeSeriesAvgRad1cmHighD)
% % hold on
% % plot(tdataYr,timeSeriesAvgRad1cmLowD)
% % ylabel('Average Radius (cm)')
% % xlabel('Years')
% % xlim([0,450])
% % title('Average Radius Over Time')
% % 
% % subplot(2,2,3.5)
% % plot(tdataYr,timeSeriesPerArea1cmHighD)
% % hold on
% % plot(tdataYr,timeSeriesPerArea1cmLowD)
% % ylabel('%')
% % xlabel('Years')
% % xlim([0,450])
% % title('Percent Area Occupied Over Time')
% % ylim([0,100])
% % % 
% % % sgtitle('\phi_g = -0.7, \phi_L = 0.7')
% % 
% % 
