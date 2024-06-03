function I=trap(f,dx)
[~,n] = size(f);
    if n ==1
        I = dx.*f;
    elseif n==2
        I = (dx/2).*(f(:,1)+f(:,end));
    else
        I=(dx/2).*(f(:,1)+f(:,end)+2*sum(f(:,2:end-1),2));%[f]*[dx]
    end
end
