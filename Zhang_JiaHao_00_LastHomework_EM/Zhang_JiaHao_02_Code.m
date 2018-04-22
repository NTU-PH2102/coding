%% Penning Trap for 1 electron
% Zhang Jia Hao 4/22/2018, NTU SPMS
% Processes the movement of a charged particle under a penning trap and
% creates a .gif file in the same folder

syms V x y z

% Basic parameters

% Electric and Magnetic parameters
V_0=-100;
B_0=[0,0,1e-6];
q_0=-1.6022e-19;
% Gravity and mass charge
g_0=0;
m_0=9.11E-31;
% Characteristic Trap Dimension
z_0=10;
p_0=10;
d_0=sqrt(1/2*(z_0^2+p_0^2/2)); 

% Velocity

% Equations
a = [0, 0, 0]; % Acceleration
v = [0, 0, 0]; % Velocity
d = [0, 0, 0]; % Position
B = q_0*cross(v,B_0); % Magnetic Influence
G = [0,0,m_0*g_0]; % Gravitational Influence
V(x,y,z) = V_0/2*(z.^2-(x.^2+y.^2)/2)/d_0.^2; % Electric Potential
% Matlab differentiation
ddX(x,y,z) = diff(V,x);
ddY(x,y,z) = diff(V,y); 
ddZ(x,y,z) = diff(V,z);
% Acceleration vector in cartesian coordinates
a = [q_0*(ddX/m_0-B(1))+G(1),q_0*(ddY/m_0+B(2))-G(2),q_0*(-ddZ/m_0+B(3))-G(3)];



%% Begin
% The above code just has to be ran once
% Running by section saves time

% Time step
timestep=1/20000000;

% Location (seed)
d = [0,0,0];
v = [0.00001,0.00001,0.00001];
% Loop
D = zeros(3,4000);
A = zeros(3,4000);
for i=1:4000
% Storing position
D(1,i)=d(1);
D(2,i)=d(2);
D(3,i)=d(3);
% Calculating next timestep (displacement)
d = d+double(v)*timestep;
ad=double(a(d(1),d(2),d(3)));
% Calculating next timestep (velocity)
v = v+ad*timestep;
B = cross(v,B_0);
% Calculating next timestep (acceleration)
a = [q_0/m_0*(ddX+B(1))+G(1),q_0/m_0*(ddY+B(2))+G(2),q_0/m_0*(-ddZ+B(3))-G(3)];
% Storing acceleration, used for debugging
A(1,i)=ad(1);
A(2,i)=ad(2);
A(3,i)=ad(3);
end

% Quick plot for check
plot3(D(1,:),D(2,:),D(3,:))


%% GIFFY
% Creating a GIF animation
for i = 1:100:size(D,2)
    plot3(D(1,1:i),D(2,1:i),D(3,1:i));
    drawnow;
    current_frame = getframe(gcf);
        [mov(:,:,1,(i-1)/100+1), map] = rgb2ind(current_frame.cdata, 256);
end

imwrite(mov, map, 'PH2102_ZHANG_JIAHAO_Animation.gif', 'delay', 0.05);
    
    
    
    
    
    
    
    
    
    
    
