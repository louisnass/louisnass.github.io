function g=gam(A,A_total,gamma,p_growth)%[cm^2]
if A<A_total
    g=gamma.*(1-(A./A_total).^p_growth);%[cm/day]
else
    g=0;
end

end