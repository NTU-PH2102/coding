%conditions for the simulation time and duration can be changed through the
%parameters here
stepSize = 5e-8;
numSteps = 10000;
duration = stepSize*numSteps;

%initial conditions
initialPosition = [.001,.001,.001];
initialVelocity = [300.0, 400.0, 50.0];

%universtal constants
%mass of electron
m = 1.66053892e-27;
%charge of electron
e = 1.602176565e-19;

%penning trap
d = sqrt(.5*(.01215^2 + .5 * .015^2));

s0 = initialPosition;
v0 = initialVelocity;
b0 = 3.7; %magnetic field
u0 = 35.75; %quadropole potential


%position radius
s0_r = sqrt(s0(1)^2 +s0(2)^2);
%position height z position
s0_z = abs(s0(3));
%velocity radius
v0_r = sqrt(v0(1)^2 +v0(2)^2);
%velocity height
v0_z = abs(v0(3));


%eigenfrequencies
omega_c = e*b0/m; %cyclotron orbit frequency
omega_z = sqrt(e*u0/(m*d^2)); %angular axial frequency
omega_l = sqrt(omega_c^2 + omega_z^2);

%ensuring that the charged electron is bounded
bounded = omega_c^2 - 2*omega_z^2 > 0; 

omega_plus = .5*(omega_c + omega_l);
omega_minus = .5*(omega_c - omega_l);

%Amplitudes
R_plus = sqrt((((e/abs(e))*v0(2)+ omega_minus*s0(1))^2 + (v0(1) - (e/abs(e))*omega_minus*s0(2))^2) / ((omega_minus-omega_plus)^2)) ;
R_minus = sqrt((((e/abs(e))*v0(2) + omega_plus*s0(1))^2 + (v0(1) - (e/abs(e))*omega_plus*s0(2))^2) /((omega_plus - omega_minus)^2)) ;
R_z = sqrt(s0(3)^2 + (v0(3)^2)/(omega_z^2));

%Phase constants
phi_plus = acos(((e/abs(e))*v0(2) + omega_minus*s0(1)) / (R_plus*(omega_minus - omega_plus)));
phi_minus = acos(((e/abs(e))*v0(2) + omega_plus*s0(1)) / (R_minus*(omega_plus - omega_minus)));
phi_z = acos(s0(3)/R_z);



t = 0;

for t = 0:stepSize:duration

%x coordinate
x_t = R_plus * cos(omega_plus * t + phi_plus) + R_minus * cos(omega_minus * t + phi_minus);
%y coordinate
y_t = (-e/abs(e)) * (R_plus * sin(omega_plus * t + phi_plus) + R_minus * sin(omega_minus * t + phi_minus));
%z coordinate
z_t = R_z * cos(omega_z*t + phi_z);

s = [x_t, y_t, z_t];

% Plot 3D plane
plot3(s(1),s(2),s(3),'.b');
hold on;
grid on;
xlabel('x'); ylabel('y'); zlabel('z');
drawnow;
view(3);

% x-y plane only
% plot(s(1),s(2),'.k');
% hold on;
% grid on;
% drawnow;
end

