%load('Coral_CAFI_FPNonUniqueParameters.mat')
phiSelect = -0.5;
Gamma=gammaDelStar;
alphaStar=Astar/A_total;
%FP 1, near alphaStar(1)
fp1=0.24;%alphaStar(1);
alphaDiff=0.05;
dAlphaDiff=0.00005;
alphaFP1StarVals=(max(0,fp1-alphaDiff):dAlphaDiff:min(1,fp1+alphaDiff))';
nFP1=length(alphaFP1StarVals);
imm = Gamma*(1-alphaFP1StarVals.^nuImm);

H=1+phiSelect*(1-alphaFP1StarVals.^2).*(1-rdata.^2./(25^2+rdata.^2));
growth = gamma*(1-alphaFP1StarVals.^nuGrowth).*H;

L=Lmin+(Lmax-Lmin)*(rdata.^beta_mort./(theta_mort^beta_mort+rdata.^beta_mort));
mort=1./L;
mortHill=mort./H;

int = - mortHill./growth;
expInt = zeros(nFP1,nr);
for j=1:nr
    integrand = trap(int(:,1:j),dr);
    expInt(:,j) = exp(integrand);
    disp(['Integrating for r =',num2str(rdata(j))])
end

u0FP1= (imm.*expInt)./(growth);

alphau0FP1=trap(pi.*rdata.^2.*u0FP1,dr)/A_total;


