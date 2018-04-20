%This part is the initialisation of the code
clear all %clear everything in matlab
clf
btm=-1; %specify the dimension of the trap. The trap is modelled to be a cube
top=1;
h=(top-btm)/10;

%Initialise particle's properties
q=1.6E-19; %charge of the particle of interest
m=1.6E-27; %mass
x0=[1,1,1]; %initial position
v0=[1,1,0].*1E7; %initial velocity

%Initialise the trap's parameter
B=[0 0 3].*1E-1; %B field
global V0 d
V0=1E6; %Max potential
z0=top;
p0=top;
d=0.5*(z0^2+(p0^2)/2);%characteristic trap dimension

%in this section, the frequencies are calculated
wc=norm(q.*B)/m; %original cyclotron freq
wz=sqrt(q.*V0/(m*d^2)) %Axial freq
wm=-((-2*wc)+sqrt((2*wc)^2-4*(2)*(wz)^2))/4 %magnetron freq
wcnew=-((-2*wc)-sqrt((2*wc)^2-4*(2)*(wz)^2))/4 %new cyclotron fre

stab=wc/sqrt(2)-wz;

if stab<0
    fprintf('The charged particle will not be bounded\n')
    %check that the parameters do indeed result in a trap, else end the
    %code
    return
end


%This part calculate the dynamics
tstep=1E-9;  %time step (try to keep it around the same order of magnitude or the system will diverge)
tEnd=3.4E-6; %End time
t=[0:tstep:tEnd];
x=[x0];
v=[v0];
for i=1:length(t)
    [Ex,Ey,Ez]=efield(x(i,1),x(i,2),x(i,3));
    if i==1 %assume a=0 for first time step
        x(i+1,:)=v0.*tstep+x(i,:);
    else
        E=[Ex, Ey, Ez];
        [X]=next(tstep,B,E,q,m,x(i,:),x(i-1,:)); %find the next position
        x(i+1,:)=X;
    end
end

%Plotting
P1=0; %initialise P1
[rx,ry,rz]=meshgrid([min(x(:,1)):(max(x(:,1))-min(x(:,1)))/10:max(x(:,1))], [min(x(:,2)):(max(x(:,2))-min(x(:,2)))/10:max(x(:,2))] ,[min(x(:,3)):(max(x(:,3))-min(x(:,3)))/10:max(x(:,3))]); %initialise the vector space

%This part plots the E field to help visualise the system. It can be
%removed without affecting the code!
hold on
%P1=plotE(rx,ry,rz);

%Animation!!!
N=length(t);
i=1;
rate=20; %This controls how many points to plot per refresh

axis([min(x(:,1)) max(x(:,1)) min(x(:,2)) max(x(:,2)) min(x(:,3)) max(x(:,3))])

grid on
xlabel('x')
ylabel('y')
zlabel('z')

while i~=N-rate
    P=plot3([x(i:i+rate,1)],[x(i:i+rate,2)],[x(i:i+rate,3)],'r','displayname','Trajectory');
    if P1~=0 %in case E field is not plotted
        legend([P,P1])
    else
        legend(P)
    end
    i=i+rate;
    
    drawnow

    %pause(0.001)

end
%}
%plot3(x(:,1),x(:,2),x(:,3),'-') %this plot the entire dynamics without animating



function [Ex,Ey,Ez]=efield(x,y,z)
%This function calulates the E field of the Penning trap given any
%coordinate (x,y,z)
global V0 d
s=sqrt(x.^2+y.^2);
V=(V0./2).*(z.^2-(s.^2)./2)./(d.^2);
for i=1:3
    eps=1E-9; %let epsilon be some very small number
    if i==1
        snew=sqrt((x+eps).^2+y.^2); %we first calculate the positive change in x
        pV=(V0/2).*(z.^2-(snew.^2)/2)./(d.^2); %change in potential
        Ex=[-(pV-V)./(eps)]; %E field is approx the gradient at that point if eps is small enough
    elseif i==2
        snew=sqrt((x).^2+(y+eps).^2);
        pV=(V0/2).*(z.^2-(snew.^2)/2)./(d.^2);
        Ey=[-(pV-V)./(eps)];
        
    else
        pV=(V0/2).*((z+eps).^2-(s.^2)/2)./(d.^2);
        Ez=[-(pV-V)./(eps)];
    end
end
end

function x=next(t,B,E,q,m,xn,x1)
%This function calculates the next position of the particle given the
%current one. It is derived from the finite difference method by Ian Cooper
q=q/m;
X1=q.*t.*(t.*E-0.5.*cross(x1,B))+2.*xn-x1;
c=q*t/2;
A=[1 -B(3)*c B(2)*c; B(3)*c 1 -B(1)*c; -B(2)*c B(1)*c 1];
x=(inv(A)*X1')';
end

function P=plotE(x,y,z)
[Ex,Ey,Ez]=efield(x,y,z); %calculate the E field (function below)
normE=(sqrt(Ex.^2+Ey.^2+Ez.^2)); %normalise the vector (optional)
P=quiver3(x,y,z,Ex./normE,Ey./normE,Ez./normE,'DisplayName','E field'); %plot normalised field
%P1=quiver3(x,y,z,Ex,Ey,Ez,'DisplayName','E field') %this gives non-normed field

end