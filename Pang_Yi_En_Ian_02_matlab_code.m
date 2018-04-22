clear all
close all

timesteps = 1000; % sets the number of time steps for the simulation 
q = 1.602E-19; % charge of particle in trap
m = 1.67E-27; % mass of particle in trap
rho0 = 1; % minimum radial distance to trap electrodes
z0 = 1; % minimum axial distance to trap electrodes
d = sqrt(0.5*(z0^2 + (rho0)^2/2)); %characteristic trap dimension

V0 = 1E6; % potential constant V0
B0 = 0.5; % magnitude of uniform magnetic field

% Initialise vectors of displacement of particle in x, y, z directions
x = zeros(1,timesteps);
y = zeros(1,timesteps);
z = zeros(1,timesteps);

h = 1E-8; % set length of discrete time steps

x(1) = 0.1; y(1) = 0.1; z(1) = 0.1; %initial position of particle

vx = 1E6; vy= 1E6; vz = 1E6; %initial velocity of particle

x(2) = x(1) + vx*2*h;
y(2) = y(1) +vy*2*h;
z(2) = z(1) +vz*2*h;

%repeatedly used constants
kE = q*(h^2)*V0/(2*m*d^2); kB = q*h*B0/(m*2); 
kz = h^2*q*V0/(m*d^2);

%displacement of particle
for t = 2:timesteps-1
    x(t+1) = (1/(1+kB^2))*(2*x(t)-x(t-1)+kE*x(t)-kB*y(t-1)+kB*(2*y(t) - y(t-1) + kE*y(t) + kB*(x(t-1))));
    y(t+1) = 2*y(t) - y(t-1) + kE*y(t) - kB*(x(t+1)-x(t-1)) ;
    z(t+1) = 2*z(t) - z(t-1) - kz*z(t);
end

%final plot of particle trajectory
figure (1) % -------------------------------------------------------------
set(gcf,'units','normalized','position',[0.670,0.6,0.3,0.3]);
plot3(x,y,z,'b','LineWidth',1);
xlabel('x  [m]'); ylabel('y  [m]'); zlabel('z  [m]');
grid on
set(gca,'fontsize',14);

%animation of particle trajectory
figure(2) %---------------------------------------------------------------
curve = animatedline('linewidth',1);
 set(gca,'XLim',[-0.5 0.5],'YLim',[-0.5 0.5],'ZLim',[-0.5 0.5])
 view(-39,27);
 xlabel('x  [m]'); ylabel('y  [m]'); zlabel('z  [m]');
for i = 1:timesteps
    addpoints(curve,x(i),y(i),z(i))
    grid 'on'
    drawnow 
end


