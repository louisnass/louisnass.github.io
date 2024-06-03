function Xbar=cafiData(lamBar,treatment)
dt=1;
T=365*10;
tdata=round(0:dt:T);

if treatment=='E'
    X0=0;
elseif treatment=='N'
    X0=lamBar;
else
    error('Decide if corals are emptied or not emptied')
end

delta=28;%28 days between CAFI jumps [days]
alpha=0.0001;%per capita removal rate of CAFI per day [1/days]
beta=0.56;%
lam=lamBar;%2-6 each month

Tn=length(tdata);
tspan=tdata(1):dt:delta-dt;
tn=length(tspan);
Inc_n=Tn/tn;

Xt=zeros(1,length(tdata));
for j=1:Inc_n 
    [tt,Xseg]=ode45(@(t,X)-alpha*X-beta*X^2,tspan,X0);
    Xt((j-1)*tn+1:j*tn)=Xseg;
    if treatment == 'E'
        Xt(j*tn)=0;
        X0=0+lam;
    elseif treatment == 'N'
        X0=Xseg(end)+lam;
    end
end
tind=length(tdata(tdata>=7*365 & tdata<=j*tn));
Xbar=mean(Xt(end-tind:end));
end