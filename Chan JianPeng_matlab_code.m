%% Penning Trap Code
%% Initialize parameters

q=-1.6*10^-19; m=9.11*10^-31;B=10^-2;V0=-10; d=7.9; timestep=1E-7; 
%q,m,B,d are charge, mass of electron, B_0 and trap dimension respectively

y0=[10^-15;0.1;10^-15;0.1;10^-15;0.1];
%6-valued INITIAL VALUE vector denoted by:
%(velocity along x,x,velocity along y,y,velocity along z,z)

%% System of 6 Ordinary Differential Equations

f = @(t,Y) [(q/m)*(B*Y(3)+(V0/(2*(d^2)))*Y(2))*timestep;Y(1);(q/m)*((V0/...
(2*d^2)*Y(4))-B*Y(1))*timestep;Y(3);(q/m)*(-V0/(d^2))*Y(6)*timestep;Y(5)];
%see accompanying note

%% Plotting trajectories as solutions

tspan=[0 1]; %duration of intended capture motion [0 n];i.e. greater n, 
%longer duration
h = figure;
[ts,ys]=ode45(f,tspan,y0); %solving intial value problem,y0 with 6 ODEs
for i=1:length(ys)
    plot3(ys(i,2),ys(i,4),ys(i,6),'*')%plot x,y,z (2nd, 4th, 6th row of ys)
    xlim([-0.2 0.2]); ylim([-0.2 0.2]); zlim([-0.1 0.1]);
    xlabel('x'); ylabel('y');zlabel('z')
    grid on
    hold on 
    drawnow %real time motion capture
    frame = getframe(h); im = frame2im(frame); %rest of code for gif
    [imind,cm] = rgb2ind(im,256); 
    if i==1
        imwrite(imind,cm,'PH2102_animation','gif','Loopcount',inf); 
    else
        imwrite(imind,cm,'PH2102_animation','gif','WriteMode','append'); 
    end
end


