%Detailed commmentry could be found in Readme file in github.
%This is to clean our list of stored variables and graphs
clc
clear all
close all

%You can adjust these value from line 6 to line 10. 
%We define the experimental constraints q,V0,d,m,B0, which is the charge, electric potential constant, trap dimension, mass and the strength of the external magnetic field respectively.
q = 1.60E-19;
m = 9.11E-31;
d = 1;
V0=5;
B0=1e-5;

%You can adjust the value of tf at line 15.
tf=0.5e-4; %This is the end time that you would want to put in
tspan=[0 tf]; %This is to define the range of time that we would want to plot our graph on.

x0 = [0 0 4e-2 1e-6 0 0]; %(x-distance, y-distance, z-distance, x-velocity, y-velocity, z-velocity)
opts = odeset('RelTol',1e-15); %To force our ODE45 differential equation software to plot within an accuracy of 10^-15 :D

[t,y]=ode45(@(t,y) Ian_Yap_Chang_Jie_02_odefcn_pt2(t,y,q,m,d,V0,B0),tspan,x0,opts); %Our heart of the software, the ODE solver. Note that we use the odefcn_pt2 which is found as a file on the other github upload

%Lazy coding, I know. Also takes up unnesscary computing power. I would
%improve this code when I have the time.
X=y(:,1); 
Y=y(:,2);
Z=y(:,3);

%Plotting of curve. Maxinum freedom by allowing the rotation of graph.
plot3(X(1),Y(1),Z(1));

%\/This is to force the graph to be fullscreen. I disabled it because it
%takes too much memory
%fig=gcf; 
%fig.Units='normalized';
%fig.OuterPosition=[0 0 1 1];
%^This is to force the graph to be fullscreen. I disabled it because it
%takes too much memory

curve = animatedline('LineWidth',3);
set(gca,'XLim', [min(X) max(X)]*1.05,'YLim', [min(Y) max(Y)]*1.05,'ZLim', [min(Z) max(Z)]*1.05);
view(3);
hold on
rotate3d on

%Labels!
xlabel('x')
ylabel('y')
zlabel('z')
title(['Motion of the Penning trap of a particle, with ' num2str(q) ' C of charge, ' num2str(m) ' kg of mass, characteristic trap dimension d=' num2str(d) ' m, electric quadrupole potential coefficient of ' num2str(V0) ' V, and a coefficient of strength of magnetic field B=' num2str(B0) ' T']) 

%Generation of the moving particle as a frame by frame construction
sizey=size(y);
for i=1:sizey(1)
    addpoints(curve,X(i),Y(i),Z(i)); %You can add a "%" sign in front of the addpoints function if you only want to see the motion of the trapped particle. 
    head = scatter3(X(i),Y(i),Z(i),'filled','MarkerFaceColor','b','MarkerEdgeColor','b'); 
    drawnow;
    current_frame=getframe(gcf);
    if i == 1
        [mov(:,:,1,i), map]=rgb2ind(current_frame.cdata, 256, 'nodither');
    else
        mov(:,:,1,i) = rgb2ind(current_frame.cdata, map, 'nodither');
    end
    delete(head);
end

%To store the animated graph as a gif.
head = scatter3(X(i),Y(i),Z(i),'filled','MarkerFaceColor','b','MarkerEdgeColor','b');
imwrite(mov ,map, 'Penning_trap.gif', 'DelayTime', 0.03, 'Loopcount', inf);
