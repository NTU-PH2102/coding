#Code for PH2102 HW 4 (Optional): 
    #Animation of charged particle motion in Penning Trap
#By: Kelvin Onggadinata     #Matric no: U1620109C   #Tut group: T2

#Important notation:
#All kinematic quantities (position, velocity, acceleration) will be in array
#The index of the array runs from 0 to N, 
#but index 0 will be meaningless to stay consitent with Ian Cooper's notation 

#The code is highly adapted by the work of Ian Cooper (University of Sydney)
#and the animation is mostly adapted by Jake Vanderplas' github code 
#and several other sources

import math
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import animation
import mpl_toolkits.mplot3d.axes3d as p3 #To plot 3d graph

#Set up the figure and the axis for the animation
fig = plt.figure()
axes = p3.Axes3D(fig)

#Initialize the number of time steps. Increase the number for longer time
N = 2000

#Initialize the constant for the particle. Here, the particle is a proton
q = 1.602*10**-19       #Particle's charge
m = 1.67*10**-27        #Particle's mass

#Initialize field value
B = 0.5                   #Magnetic field B in T. B field only in z-direction
V0 = 0.5*10**5               #Electric quadrupole potential strength constant
z_0 = 0.4                   #Endcap  position
s_0 = math.sqrt(2)*z_0      #Ring electrode position
d = math.sqrt(0.5*(z_0**2+(s_0**2)/2))      #Characteristic trap dimension

#Dimensions of volume element and field region
#The XY plane is confined by the ring electrode
xMax = s_0
xMin = -xMax
yMax = s_0
yMin = -yMax
#The Z axis is confined by the two endcap
zMax = z_0
zMin = -zMax

#Volume element that specify the field region
xFMax = 1.0
xFMin = -xFMax
yFMax = xFMax
xFMin = -yFMax
zFMax = xFMax
zFMin = -zFMax

#Initial position and velocites of the charged particle
x0 = -0.2
y0 = 0.2
z0 = 0
ux = 5*10**5
uy = 5*10**5
uz = 1*10**5

#Time setup, initialize the time interval \delta t = h
if B==0:
    h = 1*10**-9
else:
    h = (0.5*m)/(q*B)
#The coefficient 0.5 in h can be adjusted as long as it is less than 1
#To get a better approximation for the trajectories, use smaller coefficient
    
#Constant k1, k2 and k3. See additional notes for more information
k1 = (q*V0*h**2)/(2*m*d**2)
k2 = (q*B*h)/(2*m)
k3 = 1/(1+k2**2)

#The data will be stored in the array from n=1 to n=N.
#n=0 (first index of array) has no meaning
#Counting starts from 1 to stay consisten with equation
#Initialize displacement vector
x = np.zeros(N+1)
y = np.zeros(N+1)
z = np.zeros(N+1)
#Initialize velocity vector
vx = np.zeros(N+1)
vy = np.zeros(N+1)
vz = np.zeros(N+1)
v = np.zeros(N+1)
#Initialize acceleration vector
ax = np.zeros(N+1)
ay = np.zeros(N+1)
az = np.zeros(N+1)

#First time step, n=1
x[1] = x0
y[1] = y0
z[1] = z0

vx[1] = ux
vy[1] = uy
vz[1] = uz

ax[1] = (q/m)*(V0*x[1]/(2*d**2)+vy[1]*B)
ay[1] = (q/m)*(V0*y[1]/(2*d**2)-vx[1]*B)
az[1] = (q/m)*(-V0/d**2)*z[1]

#Second time step, n=2
x[2] = x[1] + vx[1]*h
y[2] = y[1] + vy[1]*h
z[2] = z[1] + vz[1]*h

#Time loops, for the subsequent time step, n>=2
#Displacement calculation
for i in range(2,N):
    if abs(x[i])<xFMax and abs(y[i])<yFMax:
        x[i+1] = k3*((k1+2)*x[i]+(k1*k2+2*k2)*y[i]+(k2**2-1)*x[i-1]-2*k2*y[i-1])
        y[i+1] = k3*((k1+2)*y[i]-(k1*k2+2*k2)*x[i]+(k2**2-1)*y[i-1]+2*k2*x[i-1])
        z[i+1] = (2-2*k1)*z[i]-z[i-1]
    else:
        x[i+1] = 1*((0+2)*x[i]+(0+2*0)*y[i]+(0**2-1)*x[i-1]-2*0*y[i-1])
        y[i+1] = 1*((0+2)*y[i]-(0+2*0)*x[i]+(0**2-1)*y[i-1]+2*0*x[i-1])
        z[i+1] = (2-2*0)*z[i]-z[i-1]
#Velocity calculation
for i in range(2,N):
    vx[i] = (x[i+1]-x[i-1])/(2*h)
    vy[i] = (y[i+1]-y[i-1])/(2*h)
    vz[i] = (z[i+1]-z[i-1])/(2*h)

vx[N] = (x[N]-x[N-1])/h
vy[N] = (y[N]-y[N-1])/h
vz[N] = (z[N]-z[N-1])/h
for i in range(len(v)):
    v[i] = math.sqrt(vx[i]**2+vy[i]**2+vz[i]**2)
#Acceleration calculation
for i in range(1,N+1):
    if abs(x[i])<xFMax and abs(y[i])<yFMax:
        ax[i] = (q/m)*(V0*x[i]/(2*d**2)+vy[i]*B)
        ay[i] = (q/m)*(V0*y[i]/(2*d**2)-vx[i]*B)
        az[i] = (q/m)*(-V0/d**2)*z[i]
    else:
        ax[i] = 0
        ay[i] = 0
        az[i] = 0

#Create the plot element
point, = axes.plot([x[1]], [y[1]], [z[1]], 'ro')
line, = axes.plot(x[1:], y[1:], z[1:])

#Establish the range of the plot and their name
axes.legend()
axes.set_title('Particle\'s motion in Penning Trap')
axes.set_xlim([xMin, xMax])
axes.set_xlabel('X axis')
axes.set_ylim([yMin, yMax])
axes.set_ylabel('Y axis')
axes.set_zlim([zMin, zMax])
axes.set_zlabel('Z axis')

#This is the animation function with iterator (or frame number) n
def animate(n, x, y, z, point):
    point.set_data(np.array([x[n], y[n]]))
    point.set_3d_properties(z[n], 'z')
    return point,

#Call the animator
ani = animation.FuncAnimation(fig, animate, N, interval = 1, fargs=(x, y, z, point))
plt.show()