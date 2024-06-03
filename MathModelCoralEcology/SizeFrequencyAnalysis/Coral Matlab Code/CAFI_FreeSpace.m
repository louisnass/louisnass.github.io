%Compute the CAFI we will use forever hopefully
%Fraction of free space

F=round(0:0.001:1,3);
nF=length(F);

rM=500;%max sized coral is 100 cm [cm]
rm=0.1;%minimum coral size 0.1 cm [cm]
dr=0.1; %increments of 1 mm=0.1cm [cm]
rdata=round(rm:dr:rM,1);%All possible radius values [cm]
nr=length(rdata);

str.dtCAFI=1;dt=str.dtCAFI;
T=365*10;
str.tdataCAFI=round(0:dt:T);tdataCAFI=str.tdataCAFI;
% 
% lam_0=10e-5;
N0=5;str.N0=N0;%Initial number of CAFI [fish]
str.delta_CAFI=28;%28 days between CAFI jumps [days]
str.alpha_CAFI=0.0001;%per capita removal rate of CAFI per day [1/days]
str.beta_CAFI=0.56;%High denisty 0.056;Low density 0.00056 [cm^2/(fish*days)]
muX=0.004;
lam0=3.3e-5;
str.lambda_CAFI=lam0+(2*lam0./(muX^2.*rdata.^2)).*(muX.*rdata+1-(muX.*rdata+muX.*deltaX+1).*exp(-muX.*deltaX)).*(F');%jump after delta days [fish/cm^2]
lam=str.lambda_CAFI;

ind_1cm=find(rdata==1);
r_val_ind=ind_1cm;
X=zeros(nF,nr);
ind_501cm=find(rdata==501);
for k=1:nF
    disp(num2str(F(k)))
    r_val_ind=1;
    for j=ind_501cm:nr
       %Here we solve the CAFI density for each radius value
       X(k,j)=CAFI(k,j,str); %[fish/cm^2]
        if j==r_val_ind
           disp(['Solving CAFI for r=',num2str(rdata(j))])
            r_val_ind=r_val_ind+10/dr;
        end
    end
end