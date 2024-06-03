% Here we will simulate environments and extract expected maximum

%We wish to do this to generate a figure similar to the summary stat
phi_range=round(-0.9:0.1:0.9,1);
nPhi=length(phi_range);
indVals=zeros(1,nPhi);
%Picking out our densities from our library
for j=1:nPhi
    indVals(j)=find(phi_g==phi_range(j) & phi_L==phi_range(j));
end

ind1cm=find(rdata==1);
rdata_mat=rdata(ind1cm:end);
nr_mat=length(rdata_mat);

uSSHighD=zeros(nPhi,nr);
uSSHighD_mat=zeros(nPhi,nr_mat);
uSSLowD=zeros(nPhi,nr);
uSSLowD_mat=zeros(nPhi,nr_mat);

for j=1:nPhi
    uSSHighD(j,:)=HighDSizeDist(end,:,indVals(j));
    uSSHighD_mat(j,:)=uSSHighD(j,ind1cm:end);
    
    uSSLowD(j,:)=LowDSizeDist(end,:,indVals(j));
    uSSLowD_mat(j,:)=uSSLowD(j,ind1cm:end);
end

totPopHighD_mat=trap(uSSHighD_mat,dr);
totPopLowD_mat=trap(uSSLowD_mat,dr);

uSSHighD_matDensity=uSSHighD_mat./totPopHighD_mat;
uSSLowD_matDensity=uSSLowD_mat./totPopLowD_mat;

avRadHighD_mat=trap(rdata_mat.*uSSHighD_matDensity,dr);
avRadLowD_mat=trap(rdata_mat.*uSSLowD_matDensity,dr);

nSims=100;

simMaxHighD=zeros(nPhi,nSims);
simMaxLowD=zeros(nPhi,nSims);

for n=1:nSims
    nCoralsHighD_mat=poissrnd(totPopHighD_mat);
    nCoralsLowD_mat=poissrnd(totPopLowD_mat);
    
    rSampsHighD=NaN(nPhi,max(nCoralsHighD_mat));
    rSampsLowD=NaN(nPhi,max(nCoralsLowD_mat));
    
    %Start by doing the HighD systems first
    r0HighD=1+exprnd(avRadHighD_mat);
    rSampsHighD(:,1)=r0HighD;
    jj=1;
    
    while jj<nPhi+1
        if nCoralsHighD_mat(jj)==0
            simMaxHighD(jj,n)=0;
            jj=jj+1;
        elseif nCoralsHighD_mat(jj)==1
            simMaxHighD(jj,n)=r0HighD(jj);
            jj=jj+1;
        else
            for kk=2:nCoralsHighD_mat(jj)
                rInit=rSampsHighD(jj,kk-1);
                rDraw=1+exprnd(avRadHighD_mat(jj));
                indSamp=find(round(rDraw,1)==rdata_mat);
                probAccept=uSSHighD_matDensity(jj,indSamp)/exppdf(rDraw,avRadHighD_mat(jj));
                U=unifrnd(0,1);
                if probAccept<U
                    %If we reject rDraw
                    rSampsHighD(jj,kk)=rInit;
                else
                    %If we accept rDraw
                    rSampsHighD(jj,kk)=rDraw;
                end
            end
            %Area check, if our samples exceed the given area, we redraw our
            %samples
            ACheck=sum(pi.*rSampsHighD(jj,1:kk).^2)/A_total;
            if ACheck < 1
                rSampsHighD(jj,1:kk)=sort(rSampsHighD(jj,1:kk),'descend');
                simMaxHighD(jj,n)=max(rSampsHighD(jj,1:kk));
                jj=jj+1;
            end    
        end
    end

    %Next do the LowD systems first
    r0LowD=1+exprnd(avRadLowD_mat);
    rSampsLowD(:,1)=r0LowD;
    jj=1;
    while jj<nPhi+1
        if nCoralsLowD_mat(jj)==0
            simMaxLowD(jj,n)=0;
            jj=jj+1;
        elseif nCoralsLowD_mat(jj)==1
            simMaxLowD(jj,n)=r0LowD(jj);
            jj=jj+1;
        else
            for kk=2:nCoralsLowD_mat(jj)
                rInit=rSampsLowD(jj,kk-1);
                rDraw=1+exprnd(avRadLowD_mat(jj));
                indSamp=find(round(rDraw,1)==rdata_mat);
                probAccept=uSSLowD_matDensity(jj,indSamp)/exppdf(rDraw,avRadLowD_mat(jj));
                U=unifrnd(0,1);
                if probAccept<U
                    %If we reject rDraw
                    rSampsLowD(jj,kk)=rInit;
                else
                    %If we accept rDraw
                    rSampsLowD(jj,kk)=rDraw;
                end
            end
            %Area check, if our samples exceed the given area, we redraw our
            %samples
            ACheck=sum(pi.*rSampsLowD(jj,1:kk).^2)/A_total;
            if ACheck < 1
                rSampsLowD(jj,1:kk)=sort(rSampsLowD(jj,1:kk),'descend');
                simMaxLowD(jj,n)=max(rSampsLowD(jj,1:kk));
                jj=jj+1;
            end    
        end
    end
    disp(['Simulated High and Low D ',num2str(n), ' times']) 
end





