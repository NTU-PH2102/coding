
%%% Section 1: Setting of parameters %%%

q = 1.6e-19; % Charge
m = 1.67e-27 * 85; % Mass of charged particle
B_0 = 5; % B-field strength
rho_0 = sqrt(2) * 1.12e-3; 
z_0 = 1.12e-3;
V_0 = 2; % E-field strength
x0 = 1; % Initial position (x-component)
y0 = 1; % Initial velocity (y-component)
z0 = 1; % Initial velocity (z-component)
ux = 0; % Initial velocity (x-component)
uy = 0; % Initial velocity (y-component)
uz = 0; % Initial velocity (z-component)
t_max = 1e-4; % Length of time to simulate
dt = 1e-7; % Length of finite time interval

d = sqrt(0.5 * (z_0^2 + (rho_0^2)/2)); % Trap characteristic


%%% Section 2: Checking for Convergence %%%

check = sqrt(2 * (m / q) * (V_0 / z_0^2));
if B_0 < check
    disp('WARNING: Particle will not be trapped')
else
    disp('Parameters are OK')
end

%%% Section 3: Calculation of constants %%%

k1 = ((q * V_0 * dt^2) / (2 * m * d^2)) + 2;
k2 = -((q * V_0 * dt^2) / (m * d^2)) + 2;
k3 = (q * B_0 * dt) / (2 * m);
k4 = 1 / (1 + k3^2);

%%% Section 4: Initialising MATLAB plot %%%

clf;
hold on;
grid on;
view(3);

%%% Section 5: Initial conditions %%%

Nintervals = round(t_max/dt);
x = zeros(Nintervals,1);
y = zeros(Nintervals,1);
z = zeros(Nintervals,1);
vx = zeros(2,1);
vy = zeros(2,1);
vz = zeros(2,1);

% Initialising for n = 1

x(1) = x0;
y(1) = y0;
z(1) = z0;
vx(1) = ux;
vy(1) = uy;
vz(1) = uz;

plot3(x(1), y(1), z(1), 'ro') % Plot the initial position of particle
drawnow;

% n = 2;

x(2) = x(1) + vx(1) * dt;
y(2) = y(1) + vy(1) * dt;
z(2) = z(1) + vz(1) * dt;

plot3(x(2), y(2), z(2), 'ro') % Plot the position of particle at n = 2
drawnow;

%%% Section 6: Computation and plotting of trajectory %%%

% n > 2;
for t = 3:Nintervals
    x(t) = k4 * ((k1 * x(t-1)) - ((1 - k3^2) * x(t-2)) + (k1 * k3 * y(t-1)) - (2 * k3 * y(t-2)));
    y(t) = k1 * y(t-1) - y(t-2) - k3 * x(t) + k3 * x(t-2);
    z(t) = k2 * z(t-1) - z(t-2);
    plot3(x(t), y(t), z(t), 'ro')
    drawnow;
end
