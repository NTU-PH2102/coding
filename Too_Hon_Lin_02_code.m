clear all
close all
clc
%===============================
%Parameter and initial values
%===============================
%define the initial value
M = 2; %ratio of B/sqrt(2mV0/qz0^2), note that M should always be >1
x0 = 1e-5;
vx = 0;
y0 = 0;
vy = 0;
z0 = 1e-5;
vz = 0;

%Define constant
q = 1.602177e-19;           %electron charge 
m = 9.109384e-31 ;          %mass of electron
c = 3.0e+8;                 %speed of light
V0 = 5.3*q*10^3;            %Maximum Electric Potential
Z = 0.001;                      %minimum axial distance for the characteristic trap
B = M*sqrt(2*m*V0/(q*Z^2));     %magnetic field, B>sqrt(2mV0/qz0^2)
p0 = sqrt(2)*Z;                 %minimum radial distance of the charecteristic trap 
                     
wz = sqrt((q*V0)/(m*Z^2));  %angular frequency along z
wc = q*B/m; 


%======================
%Set Up
%======================
%define the constant
a1 = 0.5*wz^2 ;
a2 = wc;
a3 = -wz^2
u0 = sqrt(x0^2 + y0^2);
vu = sqrt(vx^2 + vy^2);

%define the time interval
t = 0:0.01:10;
%================================
%Solve ODE using numerical method
%================================
% define the system of ode
f = @(t,s)[ s(2);
            a1*s(1)-i*a2*s(2);
            s(4);
            a3*s(3)]
 % solve the ode using build in function ode45(Runge-Kutta algorithm)
[t X] = ode45(f,t,[u0 vu z0 vz]);

%====================
%Data Analysis
%====================
%define the position matrix x,y,z, velocity matrix,xv,yv,zv and
%acceleration matrix ax,ay,az
n = length(X(:,1));
x = zeros(1,n);     y = x;      z = x;
xv = x;     yv = y;     zv = X(:,4); v = x;
ax = x;     ay = y;     
az = a3.*X(:,3);
a = a1.*X(:,1)-i.*a2.*X(:,2);
%plot the trajectory
grid on
figure(1)
for i = 1:n
    xv(i) = real(X(i,2));
    yv(i) = imag(X(i,2));
    v(i) = sqrt(xv(1)^2 +yv(i)^2 +zv(i)^2);
    ax(i) = real(a(i));
    ay(i) = imag(a(i));
    x(i) = real(X(i,1));
    y(i) = imag(X(i,1));
    z(i) = X(i,3);
    plot3(x,y,z)
    title('Trajectory of the particle in Penning trap')
    xlabel('x');ylabel('y');zlabel('z');
    drawnow;
end
figure(2)
hold on
plot(t,z,'b')
plot(t,x,'r')
plot(t,y,'k')
legend('z','x','y')
title('Position of the particle against time')
xlabel('Time,t/s');ylabel('Position/ m');
hold off
figure(3)
plot(t,v)
title('Velocity of the particle against time')
xlabel('Time,t/s');ylabel('Velocity/ ms-1');
figure(4)
hold on
plot(t,ax,'b')
plot(t,ay,'r')
plot(t,az,'k')
legend('ax','ay','az')
hold off
title('Acceleration of the particle against time');
xlabel('Time,t/s');ylabel('Acceleration/ ms-2');
figure(5)
plot(x,y)
title('x-y plane Trajectory');
