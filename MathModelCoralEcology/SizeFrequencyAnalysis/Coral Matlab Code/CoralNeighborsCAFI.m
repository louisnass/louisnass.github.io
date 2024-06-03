%CAFI settlement rate for 2 corals, different sizes nearby
%We will fix 1 coral to be 1m=100cm in radius, and vary the size of its
%neighborn (we call the fixed sized coral R2)
dr=0.1;
rM=500;
rm=0.1;
R=round(rm:dr:rM,2);
nR=length(R);

% dr1=10;
% R1=round(1:dr1:500);
% nr1=length(R1);
% 
% 
% R2=10;%100;10;
% indR2=find(R==R2);

R1=10;%100;%10;
indR1=find(R==R1);

dr2=10;

R2=round(1:dr2:500);
nr2=length(R2);


%Our environment must contain the entirety of both corals and their
%threshold radius
% L=2*(Rstar(end)+Rstar(indR2));
% H=2*max(Rstar(end),Rstar(indR2));

L=2*(Rstar(end)+Rstar(indR1));
H=2*max(Rstar(end),Rstar(indR1));
A=L*H;

% x2cent=L-Rstar(indR2);
% x2edge=x2cent-R2;
% y2cent=0.5*H;


%We compute this for all R values of R1 and the distances away
dD=50;
% d=0:dD:ceil(Rstar(end)+Rstar(indR2)-R(indR2)-R(end));
 d=0:dD:ceil(Rstar(end)+Rstar(indR1)-R(indR1)-R(end));
nD=length(d);


lamBar=zeros(nr2,nD);
lamBarRatio=lamBar;


lam0=10^(-5);
mu=0.004;


%ReDo this code.... not making sense atm
for j=1:nr2
    %%%Vary focal, fix neighbor
    % x1edge=x2edge;
    % x1cent=x2edge-R1(j);
    % y1cent=0.5*H;
    % indR1=find(R1(j)==R);

    %%%Fix focal, vary neighbor
    indR2=find(R2(j)==R);
    x2cent=L-Rstar(indR2);
    x2edge=x2cent-R2(j);
    y2cent=0.5*H;

    x1edge=x2edge;
    x1cent=x1edge-R1;
    y1cent=0.5*H;
    indR1=find(R1==R);

    for k=1:nD
        % disp(['Coral radius = ',num2str(R1(j)),' cm, Edge distances = ',num2str(d(k)),' cm'])
         disp(['Neighbor radius = ',num2str(R2(j)),' cm, Edge distances = ',num2str(d(k)),' cm'])
        if k>1
            x1cent=x1cent-dD;
            x1edge=x1edge-dD;
        end
            %If both corals do not have overlapping Rstars, then they are
            %'isolated'
        if abs(x1cent-x2cent)>Rstar(indR1)+Rstar(indR2)
            %%%Vary focal, fix neighbor
            % lamBar(j,k)=lam0*pi*R1(j)^2+(2*pi*lam0/(mu^2))*...
            %     (mu*R1(j)+1-(mu*Rstar(indR1)+1)*exp(-mu*(Rstar(indR1)-R1(j))));

            %%%Fix focal, vary neighbor
            lamBar(j,k)=lam0*pi*R1^2+(2*pi*lam0/(mu^2))*...
                (mu*R1+1-(mu*Rstar(indR1)+1)*exp(-mu*(Rstar(indR1)-R1)));
        else
            %If there is overlap, we must do Monte Carlo integration
            %Monte Carlo integration for each radius value
            N=500000;
            xSamps=unifrnd(0,L,N,1);
            ySamps=unifrnd(0,H,N,1);

            sampDists1=sqrt((x1cent-xSamps).^2+(y1cent-ySamps).^2);
            sampEdgeDist1=sampDists1-R1;%sampDists1-R1;%sampDists1-R1(j);
            sampEdgeDist1(sampEdgeDist1<0)=0;

            c1=zeros(N,1);

            %Sample land on coral
            onCoralCheck1=sum(sampEdgeDist1<=0);
            if onCoralCheck1>0
                onCoralInd1=find(sampEdgeDist1<=0);
                c1(onCoralInd1)=c(indR1,1);
            end

            %Sample land outside but in delta

            deltaCoralCheck1=sum(sampEdgeDist1>0 & sampEdgeDist1<=Rstar(indR1)-R1);
            % deltaCoralCheck1=sum(sampEdgeDist1>0 & sampEdgeDist1<=Rstar(indR1)-R1(j));
            % deltaCoralCheck1=sum(sampEdgeDist1>0 & sampEdgeDist1<=Rstar(indR1)-R1);
            if deltaCoralCheck1>0
                deltaCoralInd1=find(sampEdgeDist1>0 & sampEdgeDist1<=Rstar(indR1)-R1);
                % deltaCoralInd1=find(sampEdgeDist1>0 & sampEdgeDist1<=Rstar(indR1)-R1(j));
                % deltaCoralInd1=find(sampEdgeDist1>0 & sampEdgeDist1<=Rstar(indR1)-R1);
                chemInd1=sum(sampEdgeDist1(deltaCoralInd1)>=X0,2);
                chemInd1(chemInd1==0)=1;
                c1(deltaCoralInd1)=c(indR1,chemInd1);
            end

            % sampEdgeDist1(sampEdgeDist1<0)=0;
            % indEdge1=find(sampEdgeDist1<=Rstar(indR1)-R1(j));
            % indChem1=sum(sampEdgeDist1(indEdge1)>R,2);
            % 
            % c1(indEdge1)=c(indR1,indChem1);

            sampDists2=sqrt((x2cent-xSamps).^2+(y2cent-ySamps).^2);
            sampEdgeDist2=sampDists2-R2(j);%sampDists2-R2;%sampDists2-R2(j);
            sampEdgeDist2(sampEdgeDist2<0)=0;

            c2=zeros(N,1);
            
            %Sample land on coral
            onCoralCheck2=sum(sampEdgeDist2<=0);
            if onCoralCheck2>0
                onCoralInd2=find(sampEdgeDist2<=0);
                c2(onCoralInd2)=c(indR2,1);
            end

            %Sample land outside but in delta

            deltaCoralCheck2=sum(sampEdgeDist2>0 & sampEdgeDist2<=Rstar(indR2)-R2(j));
            % deltaCoralCheck2=sum(sampEdgeDist2>0 & sampEdgeDist2<=Rstar(indR2)-R2);
            % deltaCoralCheck2=sum(sampEdgeDist2>0 & sampEdgeDist2<=Rstar(indR2)-R2(j));
            if deltaCoralCheck2>0
                deltaCoralInd2=find(sampEdgeDist2>0 & sampEdgeDist2<=Rstar(indR2)-R2(j));
                % deltaCoralInd2=find(sampEdgeDist2>0 & sampEdgeDist2<=Rstar(indR2)-R2);
                % deltaCoralInd2=find(sampEdgeDist2>0 & sampEdgeDist2<=Rstar(indR2)-R2(j));
                chemInd2=sum(sampEdgeDist2(deltaCoralInd2)>=X0,2);
                chemInd2(chemInd2==0)=1;
                c2(deltaCoralInd2)=c(indR2,chemInd2);
            end

            % sampEdgeDist2(sampEdgeDist2<0)=0;
            % indEdge2=find(sampDists2<=Rstar(indR2));
            % indChem2=sum(sampEdgeDist2(indEdge2)>R,2);
            % 
            % c2(indEdge2)=c(indR2,indChem2);

            % indTravel=find(sampEdgeDist1>0);

            F=c1./(c1+c2);
            F(isnan(F))=0;
            F=F.*exp(-mu.*sampEdgeDist1);

            % for n=1:N
            %     %%%Vary focal, fix neighbor
            %     % if sampDists2(n)<=R2
            %     %     c2=c(indR2,1);
            %     % elseif R2<sampDists2(n) && sampDists2(n)<Rstar(indR2)
            %     %     sampEdgeDist2=sampDists2(n)-R2;
            %     %     sampEdgeInd2=find(X0==sampEdgeDist2);
            %     %     c2=c(indR2,sampEdgeInd2);
            %     % else
            %     %     c2=0;
            %     % end
            %     % if sampDists1(n)<=R1(j)
            %     %     c1=c(indR1,1);
            %     % 
            %     %     F(n)=c1/(c1+c2);
            %     % 
            %     % elseif R1(j)<sampDists1(n) && sampDists1(n)<Rstar(indR1)
            %     %     sampEdgeDist1=sampDists1(n)-R1(j);
            %     %     sampEdgeInd1=find(X0==sampEdgeDist1);
            %     %     c1=c(indR1,sampEdgeInd1);
            %     % 
            %     %     F(n)=(c1/(c1+c2))*exp(-mu*sampEdgeDist1);
            %     % else
            %     %     F(n)=0;
            %     % end
            % 
            %     %%%Fixed focal, vary neighbor
            %     if sampDists2(n)<=R2(j)
            %         c2=c(indR2,1);
            %     elseif R2(j)<sampDists2(n) && sampDists2(n)<Rstar(indR2)
            %         sampEdgeDist2=sampDists2(n)-R2(j);
            %         sampEdgeInd2=find(X0==sampEdgeDist2);
            %         c2=c(indR2,sampEdgeInd2);
            %     else
            %         c2=0;
            %     end
            % 
            %      if sampDists1(n)<=R1
            %         c1=c(indR1,1);
            % 
            %         F(n)=c1/(c1+c2);
            % 
            %     elseif R1<sampDists1(n) && sampDists1(n)<Rstar(indR1)
            %         sampEdgeDist1=sampDists1(n)-R1;
            %         sampEdgeInd1=find(X0==sampEdgeDist1);
            %         c1=c(indR1,sampEdgeInd1);
            % 
            %         F(n)=(c1/(c1+c2))*exp(-mu*sampEdgeDist1);
            %     else
            %         F(n)=0;
            %     end
            % end

            lamBar(j,k)=((lam0*A)/(N))*sum(F);

        end
    end
    lamBarRatio(j,:)=lamBar(j,:)./(lam0*pi*R1^2+(2*pi*lam0/(mu^2))*(mu*R1+1-(mu*Rstar(indR1)+1)*exp(-mu*(Rstar(indR1)-R1))));
    % lamBarRatio(j,:)=lamBar(j,:)./(lam0*pi*R1(j)^2+(2*pi*lam0/(mu^2))*(mu*R1(j)+1-(mu*Rstar(indR1)+1)*exp(-mu*(Rstar(indR1)-R1(j)))));
    % lamBarRatio(j,:)=lamBar(j,:)./(lam0*pi*R1(j)^2+(2*pi*lam0/(mu^2))*(mu*R1(j)+1-(mu*Rstar(indR1)+1)*exp(-mu*(Rstar(indR1)-R1(j)))));
end

% lamBarPct=lamBar./(lam0*pi*R1^2+(2*pi*lam0/(mu^2))*(mu*R1+1-(mu*Rstar(indR1)+1)*exp(-mu*(Rstar(indR1)-R1))));

figure()
contourf(R2/100,d/100,lamBar','LineWidth',1)
colormap("cool")
cc1=colorbar;
cc1.Label.String='Number of CAFI settlers';
cc1.Label.Rotation = 270;
cc1.Label.VerticalAlignment = "bottom";

% title(['CAFI settlers to varying focal coral and neighbor w/ r = ',num2str(R2/100),'m'])
% xlabel('Focal coral radius (m)')

title(['CAFI settlers to a focal coral w/ r = ',num2str(R1/100), 'm and varying neighbor size'])
xlabel('Neighbor coral radius (m)')

ylabel('Distance from coral edges (m)')

figure()
contourf(R2/100,d/100,lamBarRatio','LineWidth',1)
colormap("cool")
cc2=colorbar;
cc2.Label.String='% of CAFI settlers';
cc2.Label.Rotation = 270;
cc2.Label.VerticalAlignment = "bottom";
caxis=([0,1]);

% title(['% of CAFI settlers to a focal coral and neighbor w/ r = ',num2str(R2/100),'m'])
% xlabel('Focal coral radius (m)')

title(['% of CAFI settlers to a focal coral w/ r = ',num2str(R1/100), 'm and varying neighbor size'])
xlabel('Neighbor coral radius (m)')

ylabel('Distance from coral edges (m)')




