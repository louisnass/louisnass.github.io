set(0,'DefaultAxesFontSize',20);set(0,'DefaultLineLineWidth',2);
%Set coral radius size cm
dr=0.1;
dr1=0.001;
rM=500;
rM1=1;
rm=0.1;
R1=round(rm:dr1:rM1-dr1,5);
R=round(rm:dr:rM,2);%round(rm:dr:rM,2);%[R1,round(rM1:dr:rM,2)];
nR=length(R);

%Set MAX CAFI larva distance from coral center cm
X0M=3000;
dX0=dr;
X0=round(rm:dX0:X0M);%round(rm:dX0:X0M);%[R1,round(rM1:dX0,X0M)];
nX=length(X0);

%Parameters
m=2;%1;%2;0.5;
D=1;
rho=10^(-4);
thresh=0.01;

c=zeros(nX,nR);

Rstar=zeros(1,nR);
Rdiff=Rstar;
AnnulusA=Rstar;

rDisp=1;
for j=1:nR
    if j==1 
        X0Val1=round(R(j):dr1:rM1-dr,5);
        X0Vals=[X0Val1,round(rM1:dX0:X0M,2)];
    elseif R(j)<rM1
        X0Val1=round(Rstar(j-1):dr1:rM1-dr,5);
        X0Vals=[X0Val1,round(rM1:dX0:X0M,2)];
    else
        X0Vals=round(Rstar(j-1):dX0:X0M,2);
    end
    % X0Vals=round(R(j):dX0:X0M,2);
    nX0Vals=length(X0Vals);
    if R(j)==rDisp
        disp(['Solving for coral size R=',num2str(R(j))])
        rDisp=rDisp+1;
    end
    x0Disp=100;
    for k=1:nX0Vals
      rVals=round(X0Vals(k)-R(j):dr:X0Vals(k)+R(j),2);
      xtilde=(X0Vals(k).^2+R(j).^2-rVals.^2)./(2.*X0Vals(k));
      ah=(X0Vals(k)-xtilde)./rVals;
      ah(1)=1;
      ah(end)=1;
      theta=acos(ah);
      K=besselk(0,sqrt(rho/D)*rVals);
      f=rVals.*theta.*K;
      c(k,j)=(m/(pi*D))*trap(f,dr);
      if c(k,j)<thresh
          Rstar(j)=X0Vals(k);
          Rdiff(j)=Rstar(j)-R(j);
          AnnulusA(j)=pi*(Rstar(j)^2-R(j)^2);
          break
      end
    end
    if X0Vals(k)==x0Disp
        disp(['Solving for ',num2str(x0Disp/100), ' meters away'])
        x0Disp=x0Disp+100;
    end
end

R=R';
Rstar=Rstar';
c=c';
c=c(:,2:end);

RStar1M=Rstar;
delta1M=Rdiff';

% C1step=diag(c,-1);

% figure()
% plot(R,Rstar)
% xlabel('R')
% ylabel('R*')
% % 
% figure()
% plot(R,Rdiff)
% xlabel('R')
% ylabel('R*-R')
% 
% deltaX=Rdiff;
% % 
% % figure()
% % plot(R,AnnulusA)
% % xlabel('R')
% % ylabel('\pi(R*^2-R^2)')
% % 
% % figure()
% % plot(R,C1step)
% % xlabel('R')
% % ylabel('Chemical Concentration 1 step away')
% 
% 
