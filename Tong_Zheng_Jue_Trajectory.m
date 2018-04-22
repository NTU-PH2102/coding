clear all
close all
clc

%-------------------------
%Define Constant
%-------------------------

q = 1.602177e-19;           %Charge of electron
m = 9.109384e-31 ;          %Mass of electron
V0 = 1*q*10^3;            %Electric potential
r0=2;                        %initial radial distant
vr0=0.2;                        %initial radial velocity
z0=7.5e-6;                        %initial displacement from xy plane
vz=0.1;                        %initial velocity in z direction
B = 1.1e-10;                  %Magnetic Field = must satisfy B<sqrt(2mV0/qz0^2)

k1=q*B/m; k2=q*V0/(20000*m*z0^2);
t= 0:0.01:25;

%With reference to https://www.physi.uni-heidelberg.de/Einrichtungen/FP/anleitungen/F47.pdf
%Solving the ODE with introduction of complex function
f=@(t,r)[   r(2)                    ; 
            -i*k1*r(2)+0.5*k2*r(1)  ;  %The i here is sqrt(-1)
            r(4)                    ;
            -k2*r(3)                ]; 
[t,xa]= ode15s(f,t,[r0 vr0 z0 vz]);
figure(1)
set(gcf,'units','normalized','position',[0.03,0.3,0.45,0.6]); 
plot3(0,0,0,'k.','MarkerSize',38); %marking center point
title('Particle trajectory in Penning trap');   %Setting title for the plot
xlabel('x');ylabel('y');zlabel('z');            %Labelling the axes
hold on
grid on
figure(2)
set(gcf,'units','normalized','position',[0.5,0.3,0.45,0.6]); 
plot(0,0,'k.','MarkerSize',20); %marking center point
hold on
grid on
xlabel('x');ylabel('y');
title('Particle trajectory in xy plane');


for i = 1:length(xa)/4
  figure(1)
  plot3(real(xa(1:4*i,1)),imag(xa(1:4*i,1)),real(xa(1:4*i,3)),'b');  
  %real part of xa(:,1) is the x axis position
  %imaginary part of xa(:,1) is the y axis position
  %real part of xa(:,3) is the z axis position
  figure(2)
  plot(real(xa(1:4*i,1)),imag(xa(1:4*i,1)),'b'); %plotting in xy plane
  drawnow;          %drawing the plot with animation
end


