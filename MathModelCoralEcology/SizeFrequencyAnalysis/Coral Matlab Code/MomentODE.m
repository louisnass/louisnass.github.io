%%System of ODE's of moments (pop, avg rad, area)
%Set parameters

Gamma=1.4/28;
gamma=2/365;
mu=1/(10*365);
Am=(100*10)^2;


phi=2;


rho=(pi*gamma^2*Gamma)/(mu^3*Am);

t=1/mu;

dtau=0.01;
Tau=100;
tauData=0:dtau:Tau;
nTau=length(tauData);

% nQuad=3;
nLines=20;

aStarNormRange=0:0.00001:1;

aStarZero=rho*(1-aStarNormRange).^3-aStarNormRange;

aStarInd=find(aStarZero<=0,1,"first");
aStar=aStarNormRange(aStarInd);
pStar=1-aStar;
lStar=(1-aStar)^2;



PNorm=Gamma/mu;
P=zeros(nTau,nLines);

LNorm=(Gamma/mu)*(gamma/mu);
L=zeros(nTau,nLines);

AvRadNorm=(Gamma/mu)*(gamma/mu);
AvRad=zeros(nTau,nLines);

ANorm=Am;
A=zeros(nTau,nLines);

 figure()
Y0=zeros(3,1);
for j=1:nLines
    % if j==1
         % Y0=[0;0;0];
    % elseif 1<j && j<=nQuad
    %     Y0=unifrnd(0,0.5,3,1);
    % elseif nQuad<j && j<=2*nQuad
    %     Y0(1:2)=unifrnd(0,0.5,2,1);
    %     Y0(3)=unifrnd(0.5,1,1,1);
    % elseif 2*nQuad<j && j<=3*nQuad
    %     Y0(1)=unifrnd(0,0.5,1);
    %     Y0(2:3)=unifrnd(0.5,1,2,1);
    % elseif 3*nQuad<j && j<=4*nQuad
    %     Y0(1:2)=unifrnd(0.5,1,2,1);
    %     Y0(3)=unifrnd(0,0.5,1,1);
    % elseif 4*nQuad<j && j<=5*nQuad
    %     Y0([1,3])=unifrnd(0.5,1,2,1);
    %     Y0(2)=unifrnd(0,0.5,1,1);
    % elseif 5*nQuad<j && j<=6*nQuad
    %     Y0(1)=unifrnd(0.5,1,1,1);
    %     Y0(2:3)=unifrnd(0,0.5,2,1);
    % elseif 6*nQuad<j && j<=7*nQuad
    %     Y0(1:2)=unifrnd(0.5,1,2,1);
    %     Y0(3)=unifrnd(0,0.5,1,1);
    % else
    %     Y0=unifrnd(0,1,3,1);%unifrnd(0,0.75,3,1);%unifrnd(0.5,1,3,1);
    % end

    % else
        Y0(1)=unifrnd(0,2*pStar,1);%betarnd(10,10);%poissrnd(Gamma/mu)/(Gamma/mu);%pStar;%unifrnd(0,2*pStar,1);%
        Y0(2)=unifrnd(0,2*lStar,1);%(gamrnd(2,5))/(gamma/(mu*2));%(gamrnd(2,5))/(gamma/(mu*2));%lStar;%
        Y0(3)=unifrnd(0,2*aStar,1);%(PNorm*Y0(1)*pi*(gamma/(mu*2))^2*(Y0(2))^2)/ANorm;%aStar;%
    % end
    % Y0(1)=unifrnd(0,2,1);
    % Y0(2)=unifrnd(0,2,1);
    % Y0(3)=unifrnd(0,1,1);

    momentData= @(tau,Y) mODE(tau,Y,rho);
    
    [tauOut,yOut] = ode45(momentData,tauData,Y0);
    
    p=yOut(:,1);
    l=yOut(:,2);
    a=yOut(:,3);

    P(:,j)=PNorm*p;
    L(:,j)=LNorm*l;
    AvRad(:,j)=LNorm*l./(phi*P(:,j));
    A(:,j)=ANorm*a;
    
    disp(['Solving moment ODE for j = ',num2str(j),'th line'])
    plot3(p,l,a,'Color',[0 0.4470 0.7410],'LineWidth',1)
    hold on
    plot3(p(1),l(1),a(1),'o','MarkerSize',10,'Color',[0 0.4470 0.7410])
    hold on
end
plot3(pStar,lStar,aStar,'*','Color',[0.8500 0.3250 0.0980],'MarkerSize',20,'LineWidth',8)
xlabel('$p^*(\tau)$','Interpreter','latex')
ylabel('$\ell^*(\tau)$','Interpreter','latex')
zlabel('$a^*(\tau)$','Interpreter','latex')

figure()
plot(P./PNorm,L./LNorm,'Color',[0 0.4470 0.7410])
hold on
plot(pStar,lStar,'*','Color',[0.8500 0.3250 0.0980],'MarkerSize',20,'LineWidth',8)
hold on
for j=1:nLines
    plot(P(1,j)/PNorm,L(1,j)/LNorm,'o','MarkerSize',10,'Color',[0 0.4470 0.7410])
    hold on
end
xlabel('$p(\tau)$','Interpreter','latex')
ylabel('$\ell(\tau)$','Interpreter','latex')
title('\textbf{Fixed} $\mathbf{a^*}$','Interpreter','latex')

figure()
plot(P./PNorm,A./ANorm,'Color',[0 0.4470 0.7410])
hold on
plot(pStar,aStar,'*','Color',[0.8500 0.3250 0.0980],'MarkerSize',20,'LineWidth',8)
hold on
for j=1:nLines
    plot(P(1,j)/PNorm,A(1,j)/ANorm,'o','MarkerSize',10,'Color',[0 0.4470 0.7410])
    hold on
end
xlabel('$p(\tau)$','Interpreter','latex')
ylabel('$a(\tau)$','Interpreter','latex')
title('\textbf{Fixed} $\mathbf{\ell^*}$','Interpreter','latex')

figure()
plot(L./LNorm,A./ANorm,'Color',[0 0.4470 0.7410])
hold on
plot(lStar,aStar,'*','Color',[0.8500 0.3250 0.0980],'MarkerSize',20,'LineWidth',8)
hold on
for j=1:nLines
    plot(L(1,j)/LNorm,A(1,j)/ANorm,'o','MarkerSize',10,'Color',[0 0.4470 0.7410])
    hold on
end
xlabel('$\ell(\tau)$','Interpreter','latex')
ylabel('$a(\tau)$','Interpreter','latex')
title('\textbf{Fixed} $\mathbf{p^*}$','Interpreter','latex')



% PStar=PNorm*pStar;
% LStar=LNorm*lStar;
% AStar=100*aStar;
% 
% figure()
% for j=1:nLines
%     plot3(P(:,j),L(:,j),100*A(:,j)/Am,'Color',[0 0.4470 0.7410],'LineWidth',1)
%     hold on
% end
% plot3(PStar,LStar,AStar,'*','Color',[0.8500 0.3250 0.0980],'MarkerSize',20,'LineWidth',8)
% xlabel('Pop')
% ylabel('Pop Length')
% zlabel('% Area Occ')
% zlim([0,100])
% 
% AvgRadStar=LNorm*lStar/(2*PStar);       
% figure()
% for j=1:nLines
%     plot3(P(:,j),AvRad(:,j),100*A(:,j)/Am,'Color',[0 0.4470 0.7410],'LineWidth',1)
%     hold on
% end
% plot3(PStar,AvgRadStar,AStar,'*','Color',[0.8500 0.3250 0.0980],'MarkerSize',20,'LineWidth',8)
% xlabel('Pop')
% ylabel('Avg. Rad')
% zlabel('% Area Occ')
% zlim([0,100])
% % 
% % %ODE's
function dYdt=mODE(tau,Y,rho)
    p=Y(1);
    l=Y(2);
    a=Y(3);

    dpdtau=-p-a+1;
    dldtau=p-l-a*p;
    dadtau=rho*l-a-rho*a*l;

    dYdt=[dpdtau;dldtau;dadtau];
end