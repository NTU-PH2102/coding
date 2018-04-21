close all; clear all; % clear all figures

% initialise the sqrtTerm for condition 1 and condition and check that they
% are satisfied. sqrtTerm here means the term under sqrt (check that they are >= 0)
sqrtTerm_c = -1;
sqrtTerm_z = -1;
while sqrtTerm_c < 0 || sqrtTerm_z < 0
    % Parameter settings and conditions checking
    d = input('Enter "d" in metre:'); % in meter
    B_0 = input('Enter "B_0" in Tesla:'); % in Tesla
    q = input('Enter "q_0" in Coulomb:'); % in coulomb
    m = input('Enter "m" in kg:'); % in kg
    V_0 = input('Enter "V_0" in Volt:'); % in volt
    A1 = input('Enter "A1" for x amplitude:'); % parameter for x
    A2 = input('Enter "A2" for y amplitude:'); % parameter for y
    B = input('Enter "B" for z amplitude:'); % parameter for z
    phi_z = input('Enter "phi_z" for z initial offset angle in radian:'); % phi_z in radian
    phi_a = input('Enter "phi_a" for azimuthal initial offset angle in radian:'); % phi_a in radian
    sqrtTerm_c = (q * B_0 /m)^2 - (2 * q * V_0) / (d^2 * m);
    sqrtTerm_z = q*V_0/(m * d^2);
end

% omega z
omega_z = sqrt(sqrtTerm_z);

% Omega c and plus/minus selection
plus_minus = 2; % arbitrary initialisation for plus minus omega c
while plus_minus ~= 0 && plus_minus ~= 1
    plus_minus = input('Choose w_c+ (0) or w_c- (1):'); 
end

omega_c = 0;
if plus_minus == 0
    omega_c = (-q*B_0/m + sqrt(sqrtTerm_c)) / 2; % given omega c
else
    omega_c = (-q*B_0/m - sqrt(sqrtTerm_c)) / 2; % given omega c
end

% Visualisation duration(actual duration is subjected to processing power) and total frame setting
frames = -1; % initialisation for frames
t = -1; % initialisation for time

while frames <= 0 % make sure it is > 0
    frames = input('Enter total number of frame for simulation:'); 
end

while t <= 0 % make sure it is > 0
    t = input('Enter time t in second for simulation:'); 
end

t = linspace(0, t, frames); % time from 0 to t with chosen frames

% force visualisation option and selection
force = -1;
while force ~= 0 && force ~= 1
    force = input('Visualise force? Yes(1) No(0):'); 
end

% for appropriate arrow scaling of forces in (x, y, z)
scale_x = abs(q*(V_0/2*(d^2)*A1+A2*B_0*omega_c))*4/abs(A1);
scale_y = abs(q*(V_0/2*(d^2)*A2+A1*B_0*omega_c))*4/abs(A2);
scale_z = abs(q*V_0*B/(d^2))*4/abs(B);

% gif output option
gif = -1;
while gif ~= 0 && gif ~= 1
    gif = input('Output animation to GIF? Yes(1) No(0):'); 
end

% Setup figure
h = figure('units','normalized','outerposition',[0 0 1 1]); % full screen

% setup gif
if gif
filename = 'motion.gif'; % filename is motion.gif
end

% Let's do computation
for i = 1:frames
current_t = t(i); % current time slice
x_point = A1 * cos(omega_c * current_t + phi_a); % equation for x at each t
y_point = A2 * sin(omega_c * current_t + phi_a); % equation for y at each t
z_point = B * cos(omega_z * current_t + phi_z); % equation for z at each t

ax = plot3(x_point, y_point, z_point, '.'); % plot current (x,y,z)

% Compute forces
f_x = q*(V_0*x_point/(2*(d^2)) + omega_c * A2 * cos(omega_c * current_t + phi_a) * B_0); % Force (x component)
f_y = q*(V_0*y_point/(2*(d^2)) + omega_c * A1 * sin(omega_c * current_t + phi_a) * B_0); % Force (y component)
f_z = -q*V_0*z_point/(d^2); % Force (z component)

% visualise forces
if force
hold on
quiver3(x_point, y_point, z_point, f_x/scale_x, 0, 0); % plot Force (x component)
hold on
quiver3(x_point, y_point, z_point, 0, f_y/scale_y, 0); % plot Force (y component)
hold on
quiver3(x_point, y_point, z_point, 0, 0, f_z/scale_z); % plot Force (z component)
end

% label
set(gca,'FontSize', 24);
xlabel('x'); ylabel('y');zlabel('z');

% set limit for x, y, z based on amplitude or parameter A, B
% set to 1 to avoid errors
if abs(A1) == 0
    A1 = 1;
end
if abs(A2) == 0
    A2 = 1;
end
if abs(B) == 0
    B = 1;
end
xlim([-abs(A1) abs(A1)]*1.1);
ylim([-abs(A2) abs(A2)]*1.1);
zlim([-abs(B) abs(B)]*1.1);
grid on;

% display title as force of 3 components
title(['F_x:' num2str(f_x) 'N F_y:' num2str(f_y)  'N F_z:' num2str(f_z) 'N']);
drawnow;
hold on;

    if gif
        % Capture the plot as an image 
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        % Write to the GIF File 
        if i == 1 % first frame
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0);
        else % other frame just append onto the previous
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0); 
        end
    end
end
