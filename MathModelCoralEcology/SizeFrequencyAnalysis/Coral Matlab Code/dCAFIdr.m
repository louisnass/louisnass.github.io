function dXdr=dCAFIdr(X,nr,dr)
    lam=dr/2;
    D=zeros(nr);
    D(1,1)=-2;
    D(end,end)=2;
    d=ones(1,nr);
    d(1)=2;
    d(end)=2;
    D=lam*(D+diag(d(1:end-1),1)-diag(d(2:end),-1));
    dXdr=D*X';
    dXdr=dXdr';
end