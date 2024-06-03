influentialRadHighD=pi.*rdata.^2.*uSSHighD;

influentialRadLowD=pi.*rdata.^2.*uSSLowD;

% indPhiVals=zeros(length(phiVals),1);
% for j=1:length(phiVals)
%     indPhiVals(j)=find(phi_range==phiVals(j));
% end

figure()
subplot(1,2,1)
for j=[5,10,15] %length(phiVals)
    semilogx(rdata,influentialRadHighD(j,:))
    hold on
end


subplot(1,2,2)
for j=[5,10,15] %length(phiVals)
    semilogx(rdata,influentialRadLowD(j,:))
    hold on
end
