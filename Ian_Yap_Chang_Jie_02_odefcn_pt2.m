function dydt = Ian_Yap_Chang_Jie_02_odefcn_pt2(t,y,q,m,d,V0,B0)
%Detailed commmentry could be found in Readme file in github.
dydt = zeros(6,1);

%To reduce the system of second order equations to the system of first
%order equations.
dydt(1) = y(4);
dydt(2) = y(5);
dydt(3) = y(6);

%Our Penning Trap equation
dydt(4) = (q/m)*((-(V0)/(2*d^2))*(-y(1))+B0*y(5));
dydt(5) = (q/m)*((-(V0)/(2*d^2))*(-y(2))-B0*y(4));
dydt(6) = (q/m)*((-(V0)/(2*d^2))*(2*y(3)));

