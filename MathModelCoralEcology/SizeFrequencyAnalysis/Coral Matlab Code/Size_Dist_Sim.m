    %Let's simulate big coral pops for 500 years with adaptive CAFI

%%Area Data
m=10;%Dimension of our habitat meters [m]
A_total=(100*m)^2;%total available area 1m=100cm [cm^2]

%%Radius Data
rM=500;%max sized coral is 100 cm [cm]
rm=0.1;%minimum coral size 0.1 cm [cm]
dr=0.1; %increments of 1 mm=0.1cm [cm]
rdata=round(rm:dr:rM,1);%All possible radius values [cm]
ind1cm=find(rdata==1);
rdata_mat=rdata(ind1cm:end);
nr=length(rdata);%Number of radius values


%%Time Data
y=450;%number of years [yr]
T=y*365;%number of days [days]
dt=5;%change in time for upwind scheme [day]
tdata=0:dt:T;%All values of time in days[day]
tdata_y=tdata/365;%All values of time in years [yrs]
nt=length(tdata);%Number of time values 
tdataYr=0:1:y;

%%Growth information
gamma=2/365;%Maximum growth [cm/day]
p_growth=nuGrowth;%2;%Considering '2' tries to touch other corals


%%Mortality information
Lmin=2.5*365;%Minimum life expectancy to be 2.5 yrs [days]
Lmax=20*365;%Maximum life expectancy to be 20 yrs [days]
beta_mort=2;
theta_mort=20;%Inflection point, happens at 20cm [cm]
% indThetaMort=find(rdata==theta_mort);
% LE=zeros(1,nr);
% LE(1:indThetaMort-1)=Lmin*ones(1,indThetaMort-1);
% LE(indThetaMort:end)=Lmax*ones(1,nr-indThetaMort+1);
% mort=1./LE;

%Phi Values
% phi_range=round(-0.9:0.1:0.9,1);
% nPhi_range=length(phi_range);
% phi_g=phi_range;%zeros(nPhi_range^2,1);
% phi_L=phi_g;
% for kk=1:nPhi_range
%     phi_g((kk-1)*nPhi_range+1:kk*nPhi_range)=phi_range;
%     phi_L((kk-1)*nPhi_range+1:kk*nPhi_range)=phi_range(kk)*ones(nPhi_range,1);
% end

% rho=[0.25;0.5;1;1.25;1.5;2];
% lrho=length(rho);
% 
% nphi=10+2*lrho;

nphi=450;%;4;

phi_g=-0.5*ones(nphi,1);
phi_L=phi_g;

%%Parameters associated to Hill of CAFI density
% theta_Hill=0.0177;%%Inflection point of Hill function [fish/cm^2]
% beta_Hill=2;%Power for Hill function [dimensionless]
% F=round(0:0.001:1,3);
% nF=length(F);
% xx=X>=theta_Hill;
% indCAFITheta=sum(xx,2);

%%dXdr
% dXdr=dCAFIdr(X,nr,dr);

%%Initial density information
 u_0=u0FP1(1:450,:);%zeros(nphi,nr);%[corals/cm]
 % u_0(2,:)=uStarSave(1,:);
 % u_0(3,:)=uStarSave(2,:);
 % u_0(4,:)=uStarSave(3,:);
% u_0(2,:)=uSSNonUniqueFPDNB2(end,:,3);
% u_0(3,:)=0.5*uSSNonUniqueFPDNB2(end,:,3);
% u_0(4,:)=0.25*uSSNonUniqueFPDNB2(end,:,3);
% % rSpan=rM/(dr*10);
% rCutOff=10;
% 
% for j=1:nphi-1
%     if j==1
%         u_0(j,:)=NCAFISS(end,:);
%     elseif j==2
%         u_0(j,rdata<=rCutOff)=NCAFISS(end,rdata<=rCutOff);
%     elseif j==3
%         u_0(j,rdata>rCutOff)=NCAFISS(end,rdata>rCutOff);
%     end
% end


% rho=[0.25;0.5;1;1.25;1.5;2];
% lrho=length(rho);
 HwoutA=(1-rdata.^2./(25^2+rdata.^2));
 dHwoutdr=dCAFIdr(HwoutA,nr,dr);

% u_prev=u_0;%[corals/cm]
% u_pres=zeros(nphi,nr);%[corals/cm]
steadyStateArea=zeros(nphi,1);

for k=2:2
    %%Parameters associated with immigration
    if k==1
        min_sized_corals=1.4*ones(nphi,1);%1.4;
        disp('Low Larva Setting')
        % u_0(11:10+lrho,:)=(rho./rM).*pStarLowD.*ones(1,nr);
        % u_0(11+lrho:end,:)=rho.*uStarLowD;
    else
        min_sized_corals=42*ones(nphi,1);%42;
        disp('High Larva Seting')
        % u_0(11:10+lrho,:)=(rho./rM).*pStarHighD.*ones(1,nr);
        % u_0(11+lrho:end,:)=rho.*uStarHighD;
    end
    days=28;
    Gamma=gammaDelStar;%min_sized_corals/days;
    p_imm=nuImm;%Considering '2' tries to land successfully
    nGamm=length(Gamma);
    
    SizeDist=zeros(y+1,nr,nphi);
    SizeDist(1,:,:)=u_0';%Saving size distributions every year
    for jj=1:nphi
       % if jj==1
       %      Gamma=1.4/28*ones(nphi,1);
       %      disp('Looking for 50\% coverage in deleterious regime')
       % elseif jj==2
       %     Gamma=1.4/28*ones(nphi,1);
       %     disp('Looking for 50\% coverage in neutral regime')
       % elseif jj==3
       %     Gamma=1.4/28*ones(nphi,1);
       %     disp('Looking for 50\% coverage in beneficial regime')
       % end
        u_prev=u_0(jj,:);
        u_pres=zeros(1,nr);
        disp_yr=100;
        tt=1;
        disp(['Phi_g=',num2str(phi_g(jj)),' Phi_L=',num2str(phi_L(jj))])
        for n=2:nt
            A_occ=trap(pi.*rdata.^2.*u_prev,dr);%area occupied by present density [cm^2]
            pA=A_occ/A_total;% percent area occupied by present density [dimensionless]

            % freeSpace=1-pA;
            % if freeSpace<0
            %     freeSpace=0;
            % end
            % 
            % freeSpaceInd=find(F==round(freeSpace,3));
            % CAFIdensity=X(freeSpaceInd,:);
            H=(1-pA^2)*HwoutA;
            hillGrowth=1+phi_g(jj).*H;%Hill(CAFIdensity,phi_g(jj),rdata,beta_Hill,theta_Hill);
            % hillGrowth=ones(1,nr);
            % hillGrowth(1:indCAFITheta(freeSpaceInd))=1+phi_g(jj);
            hillLifeExp=hillGrowth;%Hill(CAFIdensity,phi_L(jj),rdata,beta_Hill,theta_Hill);
            % hillLifeExp=hillGrowth;
            %dhdX=dHilldX(CAFIdensity,phi_g(jj),beta_Hill,theta_Hill);
            % dhdX=zeros(1,nr);
            %dhdX(indCAFITheta(freeSpaceInd))=1/dr;
            %dCAFIdensitydr=dXdr(freeSpaceInd,:);
            dhdr=phi_g(jj)*(1-pA^2)*dHwoutdr;

            gt=gam(A_occ,A_total,gamma,p_growth).*hillGrowth;%Growth at time tdata(n+1) [cm/day] 

            dgdr=gam(A_occ,A_total,gamma,p_growth).*dhdr;%dhdX.*dCAFIdensitydr;%+...
                %gam(A_occ,A_total,gamma,p_growth).*dgdr.*hillGrowth;%Deriv of growth wrt r [1/day]

            lt=life_expectancy(rdata,Lmin,Lmax,beta_mort,theta_mort).*hillLifeExp;%Life expectancy at time tdata(n+1) days
            % lt=LE.*hillLifeExp;
            mt=1./lt;%Mortality at time tdata(n+1) [1/day]
            if A_occ<A_total
                recruits=(dt/dr).*Gamma.*(1-(A_occ./A_total).^p_imm);%[day]*[corals/day*cm]=[corals/cm]
                 u_pres(1)=u_prev(1)-dt.*(gt(1)./dr+mt(1)+dgdr(1)).*u_prev(1)+recruits;%[corals/cm]
            else
                recruits=0;
                u_pres(1)=0;
            end
           
            for j=2:nr
                if gt(j)> dr/dt%CFL condition check
                    error('CFL condition broken')
                end
                %(1-[days]*([1/cm]*[cm/days]+[1/days]+[1/days]))*[corals/cm]+[days/cm]*[cm/days]*[corals/cm]=
                %[corals/cm]
                u_pres(j)=(1-dt.*((1./dr).*gt(j)+mt(j)+dgdr(j))).*u_prev(j)+(dt/dr).*gt(j).*u_prev(j-1);
            end    
            u_prev=u_pres; %[corals/cm]
            if tdata_y(n)==tt
                SizeDist(tt+1,:,jj)=u_pres;
                tt=tt+1;
            end

            if tdata_y(n)==disp_yr
                disp(['Solving PDE for year ',num2str(tdata_y(n))])
                disp_yr=disp_yr+100;
            end
        end
        steadyStateArea(jj)=(100/A_total)*trap(pi.*rdata.^2.*u_pres,dr);
    end
    
    if k==1
       LowDSizeDist2=SizeDist;
    else
       uSS=SizeDist;
    end 
end



%save('Coral_CAFI_Size_Dists3.mat','LowDSizeDist','HighDSizeDist','phi_g','phi_L','tdataYr','rdata')

% loglog(rdata(10:end),mortBen(:,10:end))
% hold on
% loglog(rdata(10:end),mortNeut(:,10:end))
% hold on
% loglog(rdata(10:end),mortDel(:,10:end))