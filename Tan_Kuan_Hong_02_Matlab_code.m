fprintf('Please enter all values in SI unit.\n') 
% Ensure users enter values in SI unit  

q = input('Enter the charge for particle trapped inside: '); 
% Prompt user enter charge of particle 
  
V0 = input('Enter volatge applied to Penning trap: '); 
% Prompt user enter voltage applied 
  
while q*V0 <= 0 
% If q*V0 not positive, ask user to enter values again 
    fprintf('Please make sure q*V0 must be positive value\n') 
    q = input('Enter the charge for particle trapped inside: '); 
    V0 = input('Enter volatge applied to Penning trap: '); 
end 
  
m = input('Enter mass of particle trapped inside: '); 
% Prompt user enter mass of particle 
  
B0 = input('Enter magnetic field applied to Penning trap: '); 
% Prompt user enter magnetic field applied 
  
d = input('Enter characteristic trap dimension: '); 
% Prompt user enter characteristic trap dimension 
  
c1 = input('Enter amplitude of cyclotron motion: '); 
% Prompt user enter amplitude of cyclotron motion 
   
c2 = input('Enter amplitude of magnetron motion: '); 
% Prompt user enter amplitude of magnetron motion 
  
z0 = input('Enter amplitude of axial oscillation: '); 
% Prompt user enter amplitude of axial oscillation 

Wz = sqrt(q*V0/(m*d^2)); 
% Compute frequency of axial oscillation 
  
Wc = q*B0/m; 
% Compute frequency of cyclotron orbit 
  
if (Wc^2 <= 2*Wz^2) 
% Wc^2 must larger than 2*Wz^2 for trapping condition 
    fprintf('Unable to trap particle.') 
    return 
end 
  
W_positive = 0.5*(Wc + sqrt(Wc^2 - 2*Wz^2)); 
% Compute W+ for particle 
  
W_negative = 0.5*(Wc - sqrt(Wc^2 - 2*Wz^2)); 
% Compute W- for particle 
  
view(3); 
% Make a 3D dimension view 
  
graph = animatedline('LineWidth',0.3); 
% Define the properties of our graph 
  
for t = 0.0:0.000005:0.005 
% Loop time from 0s to 0.005s, which steps of 0.000005s 
    x = c1*cos(W_positive*t)+c2*cos(W_negative*t); 
    y = -c1*sin(W_positive*t)-c2*sin(W_negative*t); 
    z = z0*cos(Wz*t); 
    % Trajectory of x,y and z
    xlabel('x') 
    ylabel('y') 
    zlabel('z') 
    addpoints(graph,x,y,z) 
    % Add a point on the plot for every t 
    drawnow; 
    % Start the animation 
end 
