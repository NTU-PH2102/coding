% Motion of a charged partilce in uniform cross B and E fields
% S.I. units used unless otherwise stated

clear all;
close all;
clc;
clf;
view(3);
hold on;
grid on;
title('Graph of position of charge')
xlabel('x position') % x-axis label
ylabel('y position') % y-axis label
zlabel('z position') % x-axis label

% =========================================================================
% INPUT PARAMETERS
% =========================================================================

% Particle  e = 1.602e-19   proton m = 1.67e-27
q = 1.602e-19;  m = 1.67e-27;

% Initial displacements
x0 = 0.001;   y0 = 0.001;   z0 = 0.001;

% Initial velocites
ux = 330;   uy = 330;   uz = 0;

% B-field strength (Only appled to Z direction)
B_0 = 5.05;

% Initial voltage strength
V_0 = 2;

% Time parameters
dt = 1e-8; % Time interval t (which is given as h in the formulas)
duration = 1e-3; % Total duration
index = round(duration/dt); % Number of intervals / plots

% Constants for penning trap 
d = 1.12e-3;

% =========================================================================
% END OF PARAMETERS INPUT
% =========================================================================

% Initializing displacement for plots
x = zeros(index,1);
y = zeros(index,1);
z = zeros(index,1);

%%%%%%%%%%%% Evaluating the parameters %%%%%%%%%%%%
%%% Derivations can be found in the rough notes %%%
k1 = ((q*dt*dt*V_0)/(2*d*d*m))+2;
k2 = (B_0*q*dt)/(2*m);

% Constant for z component
% Independent of x and y
kz = -(q*V_0*dt*dt)/(m*d*d)+2;

% Initialising for n = 1
x(1) = x0;
y(1) = y0;
z(1) = z0;

plot3(x(1),y(1),z(1),'b.')
drawnow;

% Initialising for n = 2 by first calculating the first two terms
% of the velocity in each direction using kinetmatics

x(2) = x(1)+ux*dt;
y(2) = y(1)+uy*dt;
z(2) = z(1)+uz*dt;

plot3(x(2),y(2),z(2),'b.')
drawnow;

% Generating plots for n = 3 onwards
% using the initialized first and second terms
for i = 3:index
    x(i) = ((1+k2^2))^(-1)*((k1*x(i-1))+((-1+k2^2)*x(i-2))+((-2)*k2*y(i-2))+(k1*k2*y(i-1)));
    y(i) = k1*y(i-1)+(-y(i-2))+(-k2*x(i))+k2*x(i-2);
    z(i) = kz*z(i-1)-z(i-2);
    
    plot3(x(i),y(i),z(i),'b.')
    drawnow;
end
