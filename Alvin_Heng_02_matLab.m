% Code adapted from Ian Cooper, School of Physics, University of Sydney
% Finite differences method is adopted
% Relevant kinematic expressions are derived in the submitted writeup

clear all
close all
clc

% =========================================================================
% INPUT PARAMETERS
% =========================================================================


%----------Parameters that user should adjust are defined here------------

% Feel free to adjust them, however the particle stays trapped only for the
% right range of values of parameters (particularly B and V0)

% Vary h if one wishes to speed up or slow down the animation

% However h cannot be too large or the time resolution is too low for the
% finite differences method to be a good approximation

% Number of time steps
   N = 3000;
   
% Time step (s)
   h = 8e-9;
   
% Particle  e = 1.602e-19   proton m = 1.67e-27
   q = 1.602e-19;     
   m = 1.67e-27;      

% B-field (T) and V0 (V) of the electric potential expression of the
% Penning trap
   B = 0.5; %units of tesla
   V0 = 1e6; %units of voltage
   
%Penning trap dimensions (z_0 and s_0 in cylindrical coordinates)
   z_0=1; 
   s_0=1; 

% Initial velocites and displacements
   ux = 1e5;   uy = 1e5;   uz = 1e5;
   x0 = 0.5;  y0 = 0.5;   z0 = 0.5;
   
% =========================================================================
% SETUP
% =========================================================================
   
% Constants as defined in the writeup
   k = V0/(z_0^2+(s_0^2)/2);   l = (q*h^2)/m;   j=(4*h^2)/(4*h^2+B^2*l^2);
   i = (B^2*l^2)/(4*h^2)-1;   p = (B*l)/(2*h);
   
% Initialize arrays
   t = [1:N] .* h;
   x  = zeros(N,1);    y  = zeros(N,1);    z  = zeros(N,1);
   
% Time step 1: n = 1   
  x(1)  = x0;    y(1)  = y0;    z(1)=z0;

% Time step 2: n = 2 (displacement = initial displacement + velocity *
% time)
  x(2) = x(1) + ux*h;   y(2) = y(1) + uy*h;    z(2)= z(1)+uz*h;

% =========================================================================
% TIME LOOPS (calculation loop)
% =========================================================================

% Displacement (expressions derived in the writeup)
   for n = 2 : N-1
         x(n+1) = j*((2+k*l)*x(n)+i*x(n-1) + p*((2+k*l)*y(n)-2*y(n-1)));
         y(n+1) = j*((2+k*l)*y(n)+i*y(n-1) - p*((2+k*l)*x(n)-2*x(n-1)));
         z(n+1) = (2-2*k*l)*z(n)-z(n-1);
   end
   
% =========================================================================
% PLOTTING
% =========================================================================

%Complete plot of particle's trajectory
figure(1)
plot3(x,y,z)
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
grid on
set(gca,'fontsize',14);
title('Plot of complete trajectory of particle in Penning trap')

%Animated plot
figure(2)
title('Animated plot of particle trajectory in Penning trap')
view(3)
curve=animatedline('LineWidth',1.5);
for ii=1:N 
   addpoints(curve,x(ii),y(ii),z(ii));
   xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
   grid on
   set(gca,'fontsize',14);
   drawnow
end
