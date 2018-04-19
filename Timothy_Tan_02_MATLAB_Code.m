disp('Ensure that only positive values are entered; otherwise, an error will occur. SI units are used.')

z0 = input('Enter the value of z0 in meters, which is the minimum axial distance to the trap electrode: ');
% Prompt the user to enter the value of z0.

p0 = input('Enter the value of p0 in meters, which is the minimum radial distance to the trap electrode: ');
% Prompt the user to enter the value of p0.

V0 = input('Enter the value of V0 in Volts, which is the voltage: ');
% Prompt the user to enter the value of V0.

m = input('Enter the mass of the particle in kilograms: ');
% Prompt the user to enter the value of m0.

q = input('Enter the magnitude the charge of the particle in Coulombs: ');
% Prompt the user to enter the magnitude of the charge of the particle.

B = input('Enter the magnitude of the magnetic field in Teslas: ');
% Prompt the user to enter the magnitude of the magnetic field.

modified_cyclotron_factor = input('Enter the modified cyclotron radius as a factor of p0 (must be greater than 0 and at most 1): ');
% Prompt the user to enter the radius of the modified cyclotron motion as a
% factor of p0, i.e. enter R where R*p0 is the radius of the modified
% cyclotron motion.

magnetron_factor = input('Enter the magnetron radius as a factor of p0 (must be greater than 0 and at most 1): ');
% Prompt the user to enter the radius of the magnetron motion as a
% factor of p0, i.e. enter R where R*p0 is the radius of the magnetron motion.

time = input('Length of time for when animation should stop in seconds: ');
% Asks the user until which point in time should the animation stop. 

step_size = input('Step size for time values in seconds: ');
% Ask the user to enter the step size for time values. A smaller time
% value will result in a smoother curve but will take longer.

characteristic_Dimension = 0.5*((z0)^2 + 0.5*(p0)^2);
% Compute the characteristic dimension of the Penning trap.

cyclotron_freq = (q*B)/m;
% Compute the cyclotron frequency (w_c) of the particle.

axial_freq = sqrt((q*V0)/m*(characteristic_Dimension)^2);
% Compute the axial frequency (w_z) of the particle.

if ((cyclotron_freq)^2 - 2*(axial_freq)^2) <= 0
    % Check the conditions entered to see whether the parameters are valid
    % for an ion to be trapped.
    print('Invalid condition to trap ions.')
    return
end

modified_cyclotron_freq = 0.5*(cyclotron_freq + sqrt((cyclotron_freq)^2 - 2*(axial_freq)^2));
% Compute the modified cyclotron frequency (w_+) of the particle.

magnetron_freq = 0.5*(cyclotron_freq - sqrt((cyclotron_freq)^2 - 2*(axial_freq)^2));
% Compute the magnetron frequency (w_-) of the particle.

curve = animatedline('LineWidth',0.5);
% Define physical properties of the curve / trajectory.

set(gca,'XLim',[-p0,p0],'YLim',[-p0,p0],'ZLim',[-1.1*z0,1.1*z0]);
% Set the boundaries of the graph.

view(3)
% Force a 3D view.

for t = 0.0:step_size:time % Go through various values of t in a for loop.

modified_cyclotron_rad = modified_cyclotron_factor*p0;
% Define the modified cyclotron radius.

magnetron_rad = magnetron_factor*p0;
% Define the magnetron radius.

% Equations of motion in Cartesian coordinates, parametrized by t:

x = modified_cyclotron_rad * cos(modified_cyclotron_freq * t) + magnetron_rad * cos(magnetron_freq * t);
y = modified_cyclotron_rad * sin(modified_cyclotron_freq * t) + magnetron_rad * sin(magnetron_freq * t);
z = z0 * cos(axial_freq * t);

title('Trajectory of Particle in a Penning Trap')
% Include the title of the animation.

xlabel('x')
ylabel('y')
zlabel('z')
% Label the 3 axes.

addpoints(curve,x,y,z)
% Add points to the curve.

drawnow
% Make an animation.

end