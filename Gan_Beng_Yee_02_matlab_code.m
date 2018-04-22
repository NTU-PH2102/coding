% Motion of a charged partilce in uniform cross B and E fields
% S.I. units used unless otherwise stated
% Explanatory writeup: https://www.sharelatex.com/read/hxfvsrzpzzph 
clear all
close all
clc

% =========================================================================
% INPUT PARAMETERS 
% =========================================================================
     
     h           = 0.01;                % time steps
     N           = 10000;                % number of time steps
     q           = 1.602e-19;           % charge of particle
     m           = 9.109384e-31;        % mass of particle
     z_o         = 0.5;                % minimum axial distance
     z_rho_ratio = 0.05 ;                % ratio between axial distance and radial distance      
     V           = q*5*10^5;            % Voltage
     V_B_ratio   = 2;                   % Voltage to Magnetic field ratio
     
     
% Initial velocites and displacements
    ux = 1e-5;  x0 = 1e-5; 
    uy = 0;     y0 = 0;
    uz = 0;     z0 = 1e-5; 

%%
% =========================================================================
% Variable and constant
% =========================================================================

% Variable
    rho_o = z_rho_ratio*z_o;                      % rho = minimum radial distance.
    d     = sqrt(1/2*(((z_o)^2+((rho_o^2)/2))));  % characteristic trap dimension
    B     = V_B_ratio* sqrt((2*m*V)/(q*d^2));     % magnetic field
    w_c   = (q*B)/m;                              % free space cyclotron frequency
    w_z   = sqrt((q*V)/(m*(d^2)));                % angular axial frequency
% Constants
    k1 = (w_c*h)/2;
    k2 = (h^2*w_z^2)/2;   
    k3 = w_z^2*h^2; k4 = 1/(1+k1^2);
 
%%
% =========================================================================
% Setup
% =========================================================================

% Initialize arrays 
    t = (1:N).* h;
    x  = zeros(N,1);   y  = zeros(N,1);   z  = zeros(N,1); 
    vx = zeros(N,1);   vy = zeros(N,1);   vz = zeros(N,1);
    ax = zeros(N,1);   ay = zeros(N,1);   az = zeros(N,1);
   
% Time step 1: n = 1   
    x(1)  = x0;  y(1)  = y0; z(1)  = z0;
    vx(1) = ux;  vy(1) = uy; vz(1) = uz;
  
    ax(1) = (w_c)* uy+ 1/2*(w_z^2)*x(1);
    ay(1) = -(w_c)* ux+ 1/2*(w_z^2)*y(1);
    az(1) = -(w_z^2)*z(1);
  
% Time step 2: n = 2
    x(2)  = x(1) + vx(1)*h;   vx(2) = vx(1) +ax(1)*h;
    y(2)  = y(1)  + vy(1)*h;   vy(2) = vy(1) +ay(1)*h;
    z(2)  = z(1) + vz(1)*h;    vz(2) = vz(1) +az(1)*h;
    
    ax(2) =  (w_c)* vy(2)+ 1/2*(w_z^2)*x(2);
    ay(2) = -(w_c)* vx(2)+ 1/2*(w_z^2)*y(2);
    az(2) = -(w_z^2)*z(2);

%%
% =========================================================================
% TIME LOOPS
% =========================================================================
% for N > 2
% Displacement
   for n = 2 : N-1
       x(n+1) = k4*((2+k2)*x(n) + (k1^2- 1)*x(n-1)+ 2*k1*y(n)- 2*k1*y(n-1)  +k1*k2*y(n));
       y(n+1) = 2*y(n) -y(n-1)- k1*x(n+1) +k1*x(n-1) +k2*y(n);
       z(n+1) = (2 -k3).*z(n) -z(n-1);
   end
 % Velocity  -------------------------------------------------------------
 for n = 2 : N-1
     vx(n) = (x(n+1) - x(n-1))/(2*h);
     vy(n) = (y(n+1) - y(n-1))/(2*h);
     vz(n) = (z(n+1) - z(n-1))/(2*h);
     
 end
     vx(N) = (x(N)-x(N-1))/h; vy(N) = (y(N)-y(N-1))/h; vz(N) = (z(N)-z(N-1))/h; 
     
 % Acceleration
 for n = 1 : N
      ax(n) =   w_c.* vy(n)+ 1/2.*(w_z^2).*x(n);
      ay(n) = - w_c.* vx(n)+ 1/2.*(w_z^2).*y(n);
      az(n) = -(w_z^2).*z(n);
 end
  
%%
% =========================================================================
% Graphics
% =========================================================================
fs          = 10;                  % font size
figure(1) % --------------------------------------------------------------
    set(gcf,'units','normalized','position',[0.05,0.6,0.3,0.35]);
    xP = 0; yP = 0;
    plot(xP,yP,'b','LineWidth',2) 
    axis([0 100 0 100]);
    px1 = 5; py1 = 105; dpx = 5; dpy = 7; px2 = 50;

% Number of elements  N
    tx1 = 'Number of time steps  N  = ';
    tx2 = num2str(N,'%4.0f\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);

% charge q
    py1 = py1 - 1.2*dpy;
    tx1 = 'Charge, q  [C]                    = ';
    tx2 = num2str(q,'%2.3e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);

% charge m
    py1 = py1 - 1.2*dpy;
    tx1 = 'Mass, m  [kg]                     = ';
    tx2 = num2str(m,'%2.3e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);
   
% magnetic field B
    py1 = py1 - 1.2*dpy;
    tx1 = 'Magnetic field, B [T]          = ';
    tx2 = num2str(B,'%2.3e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);
   
% electric field E
    py1 = py1 - 1.2*dpy;
    tx1 = 'Voltage, V [V]                     = ';
    tx2 = num2str(V,'%2.2e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);
    axis off
    
% Minimum axial distance, z_o
    py1 = py1 - 1.8*dpy;
    tx1 = 'Minimum axial distance, z_o [m]    = ';
    tx2 = num2str(z_o,'%2.2e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);
    axis off

% Minimum radial distance, rho_o
    py1 = py1 - 1.2*dpy;
    tx1 = 'Minimum radial distance, \rho_o [m]    = ';
    tx2 = num2str(rho_o,'%2.2e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);
    axis off
    
% characteristic trap dimension, d^2
    py1 = py1 - 1.2*dpy;
    tx1 = 'Characteristic trap dimension, d^2 [m^2]    = ';
    tx2 = num2str(d^2,'%2.2e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);
    axis off
    
% initial positions x y z
    py1 = py1 - 1.8*dpy;
    tx1 = 'Initial values (t = 0 s) for displacement [m]';
    tx2 = ' ';
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);  
   
    py1 = py1 - 1.2*dpy;
    tx1 = '   x_0 = ';
    tx2 = num2str(x(1),'%2.2f\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);   
   
    px1 = px1 + 5*dpx;
    tx1 = '   y_0 = ';
    tx2 = num2str(y(1),'%2.2f\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs); 
   
    px1 = px1 + 5*dpx;
    tx1 = '   z_0 = ';
    tx2 = num2str(z(1),'%2.2f\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs); 
   
% initial velocities vx vy vz
    py1 = py1 - 1.5*dpy;
    px1 = px1 - 10*dpx;
    tx1 = 'Initial values (t = 0 s) for velocity [m/s]';
    tx2 = ' ';
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);  

    py1 = py1 - 1.2*dpy;
    tx1 = '   u_x = ';
    tx2 = num2str(vx(1),'%2.2e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);   
 
    px1 = px1 + 6*dpx;
    tx1 = '   u_y = ';
    tx2 = num2str(vy(1),'%2.2e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs); 
   
    px1 = px1 + 6*dpx;
    tx1 = '   u_z = ';
    tx2 = num2str(uz(1),'%2.2e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);
   
 % time step h
    py1 = py1 - 1.5*dpy;
    px1 = px1 - 12*dpx;
    tx1 = 'Time step [s]  h = ';
    tx2 = num2str(h,'%2.2e\n');
    tx3 = '  ';
    tx = [tx1 tx2 tx3];
    h_text = text(px1,py1,tx); set(h_text,'fontsize',fs);
   
    axis off

figure(2) % --------------------------------------------------------------
    set(gcf,'units','normalized','position',[0.36,0.6,0.3,0.3]);     
    fs = 14;
    plot(x,y);
    xlabel('x [m]'); ylabel('y [m]')
    title('2D trajectory')
    set(gca,'fontsize',fs);

figure(3) % --------------------------------------------------------------
    set(gcf,'units','normalized','position',[0.670,0.6,0.3,0.3]); 
    plot(t,x,'r','LineWidth',2);
    hold on
    plot(t,y,'b','LineWidth',2);
    hold on
    plot(t,z,'k','LineWidth',2);

    grid on
    legend('x','y','z')
    xlabel('Displacement [m]')
    ylabel('t [s]')
    title('Displacement versus Time')
    set(gca,'fontsize',fs);

figure(4) % --------------------------------------------------------------
    set(gcf,'units','normalized','position',[0.05,0.1,0.3,0.3]);
    plot(t,vx,'r','LineWidth',2);
    hold on
    plot(t,vy,'b','LineWidth',2);
    hold on
    plot(t,vz,'k','LineWidth',2);

    grid on
    legend('v_x','v_y','v_z')
    xlabel('Velocity [ms^{-1}]')
    ylabel('t [s]')
    title('Velocity versus Time')
    set(gca,'fontsize',fs);

figure (5) % -------------------------------------------------------------
    set(gcf,'units','normalized','position',[0.36,0.1,0.3,0.3]);
    plot(t,ax,'r','LineWidth',2);
    hold on
    plot(t,ay,'b','LineWidth',2);
    hold on
    plot(t,az,'k','LineWidth',2);

    grid on
    legend('a_x','a_y','a_z')
    xlabel('Acceleration [ms^{-2}]')
    ylabel('t [s]')
    title('Acceleration versus Time')
    set(gca,'fontsize',fs);
   
figure (6) % -------------------------------------------------------------
    set(gcf,'units','normalized','position',[0.67,0.1,0.3,0.3]); 
    curve = animatedline('LineWidth',2);
    set(gca,'FontSize', 12);
    xlabel('x [m]'); ylabel('y [m]');zlabel('z [m]');
    title('Animation of 3D trajectory')
    set(gca,'fontsize',fs); 
    xlim([min(x) max(x)]*1.05);
    ylim([min(y) max(y)]*1.05); 
    zlim([min(z) max(z)]*1.05);
    grid on;
    hold on
    view(43,24);

    for i = 1:N
        addpoints(curve,x(i),y(i),z(i))
        head = scatter3(x(i),y(i),z(i),'fill');
        drawnow; 
        delete(head);
    end
