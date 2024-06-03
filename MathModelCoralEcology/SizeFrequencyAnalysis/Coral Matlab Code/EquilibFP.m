alph=0:0.005:1;
nAlph=length(alph);
F=alph.*(1-alph.^nuGrowth)./(1-alph.^nuImm);
L=Lmin+(Lmax-Lmin)*(rdata.^beta_mort./(theta_mort^beta_mort+rdata.^beta_mort));
mort=1./L;

H=(1-alph'.^2).*(1-rdata.^2./(25^2+rdata.^2));

phiSelect=-0.5;
% figure()
% plot(alph,F,'k--')
dGammaDel=0.005;
GammaDel=0.1:dGammaDel:1.1*GammaDelEnd;

nGammaDel=length(GammaDel);
GSave=zeros(3,nAlph);
alphSave=NaN(3,nGammaDel);
num2Ints=0;
saveInts=0;
for jj=1:nGammaDel
    gammaDel=GammaDel(jj);
    alphDisp=0.1;
    for k=1:1
        G=zeros(nAlph,1);
        for j=1:nAlph
            exInt=zeros(1,nr);
            for kk=1:nr 
                exInt(kk)=trap(mort(1:kk)./(1+phiSelect(k).*H(j,1:kk)).^2,dr);
                exInt(kk)=exp(-exInt(kk)/(gamma*(1-alph(j)^nuGrowth)));
                
            end
            if round(alph(j),3)==round(alphDisp,3)
                disp(['Solving for alpha= ',num2str(alphDisp)])
                alphDisp=alphDisp+0.1;
            end
            G(j)=gammaDel*pi*trap(rdata.^2.*exInt./(1+phiSelect(k).*H(j,1:kk)),dr)/(gamma*A_total);
        end
     
        hold on
        % plot(alph,G,'Color',Dcolor)
        
    end
    % ylim([0,1.2])
    tf=G'<F;
    dtf=abs(tf(2:end-1)-tf(1:end-2));
    alphStar=alph(dtf==1);
    numInts=length(alphStar);
    if numInts==2
        num2Ints=num2Ints+1;
    end

    if numInts==1
        if num2Ints<2
            alphSave(1,jj)=alphStar;
        else
            alphSave(3,jj)=alphStar;
        end
    elseif numInts==2
        alphSave(1,jj)=alphStar(1);
        alphSave(3,jj)=alphStar(2);
    else
        if num2Ints<2
            num2Ints=4;
        end
        alphSave(:,jj)=alphStar;
    end
    disp(['Solved ',num2str(jj),' out of ',num2str(nGammaDel),' iterations'])
    if saveInts==0
        if GammaDel(jj)>GammaDel1
            saveInts=saveInts+1;
            GSave(1,:)=G;
        end
    elseif saveInts==1
        if GammaDel(jj)>GammaDel1*2
            saveInts=saveInts+1;
            GSave(2,:)=G;
        end
    elseif saveInts==2
        if GammaDel(jj)>GammaDel1*4
            saveInts=saveInts+1;
            GSave(3,:)=G;
        end
    end
end

figure()
plot(GammaDel,alphSave(1,:),'Color',Bcolor)
hold on
plot(GammaDel,alphSave(2,:),'Color',Ncolor)
hold on
plot(GammaDel,alphSave(3,:),'Color',Dcolor)
xlabel('\Gamma_0')
ylabel('\alpha^*')
title('Fixed point bifurcation map wrt immigration rate for deleterious CAFI')

figure()
plot(alph,F,'-k')
hold on
plot(alph,GSave(1,:),":",'Color',Dcolor)
hold on
plot(alph,GSave(2,:),'-.','Color',Dcolor)
hold on
plot(alph,GSave(3,:),'Color',Dcolor)
xlabel('\alpha')
title('F and G')

% tf=G'<F;
% dtf=abs(tf(2:end-1)-tf(1:end-2));
% alphStar=alph(dtf==1);
% uStar=zeros(3,nr);
% for jj=1:3
%     I=zeros(1,nr);
%     for kk=1:nr
%         Hint=(1+phiSelect*(1-alphStar(jj)^2).*(1-rdata(1:kk).^2./(25^2+rdata(1:kk).^2)));
%         integrand=mort(1:kk)./(Hint.^2);
%         I(kk)=trap(integrand,dr)./(gamma.*((1-alphStar(jj).^nuGrowth)));
%     end
%     uStar(jj,:)=GammaDel*(1-alphStar(jj)^nuImm).*exp(-I)./(gamma...
%         .*(1-alphStar(jj)^nuGrowth).*Hint);
% end
% AStarChk=trap(pi*rdata.^2.*uStar,dr);

%legend('$F(\alpha)$', ['$G(\alpha), \phi = $',num2str(phiSelect(1))],'Interpreter','latex')%,...
   % ['$G(\alpha), \phi = $',num2str(phiSelect(2))], ['$G(\alpha), \phi = $',num2str(phiSelect(3))],...
    %'Interpreter','latex')