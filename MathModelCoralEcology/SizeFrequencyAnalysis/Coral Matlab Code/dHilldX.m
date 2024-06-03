function dhdX=dHilldX(X,phi,beta,theta)
dhdX=phi.*(beta.*theta.^(beta).*X.^(beta-1))./((theta^beta+X.^(beta)).^2);
end
