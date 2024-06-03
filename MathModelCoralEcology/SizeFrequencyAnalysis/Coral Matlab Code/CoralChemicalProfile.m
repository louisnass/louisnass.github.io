%%2D coral chemical profiles
rCoral1=2;
coral1Cent=0;
coral1Edge=coral1Cent+rCoral1;
rCoral1Ind=find(R==rCoral1);
cCoral1=[fliplr(c(rCoral1Ind,:)),c(rCoral1Ind,1)*ones(1,2*rCoral1Ind+1),c(rCoral1Ind,:)];
xCoral1=round([-fliplr(X0)-rCoral1,-rCoral1,-fliplr(R(R<rCoral1)'),0,R(R<rCoral1)',rCoral1,X0+rCoral1]+coral1Cent,1);



rCoral2=1;
coral2Edge=coral1Edge;
coral2Cent=coral2Edge+rCoral2;
rCoral2Ind=find(R==rCoral2);
cCoral2=[fliplr(c(rCoral2Ind,:)),c(rCoral2Ind,1)*ones(1,2*rCoral2Ind+1),c(rCoral2Ind,:)];
xCoral2=[-fliplr(X0)-rCoral2,-rCoral2,-fliplr(R(R<rCoral2)'),0,R(R<rCoral2)',rCoral2,X0+rCoral2]+coral2Cent;

figure()
for j=1:4
    subplot(2,2,j)
    patch(xCoral1/100,cCoral1,'red')
    alpha(0.1);
    hold on
    patch(xCoral2/100+(j-1),cCoral2,'blue')
    alpha(0.1);
    xlim([-1,5])
    if j==1
        title('Touching')
    else
        title([num2str(j-1),' m away'])
    end

    xlabel('Edge distance (m)')
    if j==1 || j==3
        ylabel('Chemical concentration')
    elseif j==2
        legend(['Coral radius ',num2str(rCoral1),' cm'],['Coral radius ',num2str(rCoral2),' cm'])
    end
    j
end
sgtitle('Chemical profile of neighboring corals')

