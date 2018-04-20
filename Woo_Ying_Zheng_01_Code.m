%% Read Me
%{

The following code is an shows the motion of a charged particle in a 
Penning Trap.
All the initial values id the "Initial Values" section could
be modified according to the user's need.

%}

%%
close all;
clear all;


%% Initial Values
% Charateristics of Particle
% Particle  e = 1.602e-19   proton m = 1.67e-27
   q = 1.602e-19;     
   m = 1.67e-27;      

% Magnetic Field
   B = 0.005;
% Voltage
   v0 = 250;
% Minimal Axial Distance
   z0 = 1;
% Minimal Radial Distance
   p0 = 10;
   
% Cyclotron Factor
   factor_c = 0.1;
% Magnetron Factor
   factor_m = 1;
   
% Number of Steps
   n = 10001;   

% Charateristic dimension
   d=1;

%% Calculating some important values
% Define time
   t = 0:0.005/n:0.0005;
% Calculate the cyclotron angular velocity of the particle
   w_c=q*B/m;
% Calculate the axial angular velocity of the particle
   w_z=sqrt((q*v0)/(m*d^2));
% Calculate the cmodified cylotron angular velocity of the particle
   w_cx=0.5*(w_c+sqrt(w_c^2-2*w_z^2));
% Calculate the magneton angular velocity of the particle
   w_m=0.5*(w_c-sqrt(w_c^2-2*w_z^2));      
% Calculate the radius of the orbit for cyclotron motion
   r_c=p0*factor_c;
% Calculate the radius of the orbit for magnetron motion
   r_m=p0*factor_m;   



if((w_c^2-2*w_z^2)<=0)
   print('Error/n');
end
   
%% Animation

x=[];
y=[];
z=[];

for i = 1:n

x = [x r_c*cos(w_cx*t(i))+r_m*cos(w_m*t(i))];
y = [y r_c*sin(w_cx*t(i))+r_m*sin(w_m*t(i))];
z = [z z0*cos(w_z*t(i))];

ax = plot3(x, y, z , '-b', 'LineWidth', 0.3);

hold on

set(gca,'FontSize', 12);

xlabel('x'); ylabel('y');zlabel('z');

xlim([-(r_c+r_m) (r_c+r_m)]*1.5);
ylim([-(r_c+r_m) (r_c+r_m)]*1.5);
zlim([-z0 z0]*1.5);

grid on;

title(['PLot of Trajectory until time =' num2str(t(i)) '.']);

drawnow;

end
