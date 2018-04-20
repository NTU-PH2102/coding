close all;
clear all;

disp('Pleasea follow the instruction and enter the required values to prodece an animation of the motion of the charged particle in a Penning trap.\n');
% Some note for the user at the beginning

V=input('Please enter the magnitude of voltage applied (in Voltage):');
% Prompt the user to key in the magnitude of volatge applied

q=input('Please enter the magnitude of charge of the particle trapped (in Coloumbs):');
% Prompt the user to key in the charge of the particle trapped

while q*V <= 0
    fprintf('Please enter a non-zero positive number')
    V=input('Please enter the magnitude of voltage applied (in Voltage):');
end
% this while loop is used to ensure the user enter an approriate value 

B=input('Please enter the magnitude of the magnetic field applied (in Tesla):');
% Prompt the user to key in the magnetic field applied 

m=input('Please enter the mass of the particle trapped (in kilogram):');
% Prompt the user to key in the mass of particle trapped

z_0=input('Please enter the minimum axial distance for characteristic trap dimension (in meter):');
% Prompt the user to key in the minimum axial distance

p_0=input('Please enter the minimum radial distance for the characteristics trap dimension (in meter):');
% Prompt the user to key in the minimum radial distance

R1=input('Please enter the amplitude of modified cyclotron motion:');
% Prompt the user to key in the amplitude of modified cyclotron motion

R2=input('Please enter the amplitude of magnetron motion:');
% Prompt the user to key in the amplitude of magnetron motion

z1=input('Please enter the amplitude of the axial mode:');
% Prompt the user the key in the amplitude of the axial mode

%============================================================================================================
%end of the input that required from the user
%============================================================================================================

d=0.5*((z_0*z_0)+((p_0*p_0)/2));
% calculate the characteristic trap dimension based on the z_0 and p_0
% enterd by the user

w_z=sqrt(q*V/m/d/d);
% calculate the axial motion frequency

w_c=q*B/m;
% calculate the cyclotron frequency

if w_c <= (sqrt(2))*w_z
    fprintf('The frequency obtained is not real and unable to produce Penning trap.');
    fprintf('For frequency to be real, w_c have to be bigger than (sqrt(2))*w_z.\n');
    fprintf('Please run the code and enter the appropriate parameter again');
    return
end

w_1=0.5*(w_c+sqrt(w_c*w_c+2*w_z*w_z));
% calculate the modified cyclotron motion frequency

w_2=0.5*(w_c+sqrt(w_c*w_c-2*w_z*w_z));
% calculate the magnetron motion frequency

%=================================================================================================
%end of calculation of parameter before produce the animation of the motion
%of charged particle in Penning trap
%=================================================================================================

x=[];y=[];z=[];
% Initialize the x,y, and z vector

t=0:0.00075:1;
%define time from 0 to 1 with the step of 0.00075

frequency=linspace(1,5,length(t));
% take frequency from 1 to 5 Hz

for ii=1:length(t);
    
    x=[x R1*cos(w_1*t(ii))+R2*cos(w_2*t(ii))];
    y=[y -R1*sin(w_1*t(ii))-R2*sin(w_2*t(ii))];
    z=[z z1*cos(w_z*t(ii))];
    % deploy the trajectory found in the ideal Penning trap
    
    ax=plot3(x,y,z,'-r','LineWidth',0.4);
    set(gca,'Fontsize',10);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    xlim([-(R1+R2) (R1+R2)]*1.05);
    ylim([-(R1+R2) (R1+R2)]*1.05);
    zlim([-z1 z1]*1.05);
    grid on;
    title(['Plot of trajectory in Penning trap']);
    drawnow;
end

