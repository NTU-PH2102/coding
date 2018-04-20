import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import matplotlib.animation as animation

#Parameters
q = 1.6*10**(-19)
B = 2*10**(-3)
V = 6*10**4
m = 9.1*10**(-31)
h = (0.01*m/(q*B))
zo = 0.6 
so = 0.9 
d = (0.5*(zo**2 + (zo**2 + so**2)/2))**0.5
k1 = q*B*h/(2*m)
k2 = q*V*(h**2)/(2*m*(d**2))
k3 = 1/(k1**2 + 1)

#Initial conditions
timestep = 10000
x0 = 0
y0 = 0
z0 = 0
vx0 = 8*10**7
vy0 = 8*10**7
vz0 = 8*10**7
ax0 = (q*V/(2*m*(d**2)))*x0 + q*vy0*B
ay0 = (q*V/(2*m*(d**2)))*y0 - q*vx0*B
az0 = -(q*V/(2*m*(d**2)))*z0

#Setting up animation variables
x = np.zeros((3, timestep))
v = np.zeros((3, timestep))
a = np.zeros((3, timestep))
x[:, 0] = [x0,y0,z0]
v[:, 0] = [vx0,vy0,vz0]
a[:, 0] = [ax0,ay0,az0]

#Iteration formula
for i in range(1, timestep):
    if (i>1):
        x[0, i] = k3*((k2 + 2)*x[0, i-1] + (k1**2 - 1)*x[0, i-2] + (k2 + 2)*k1*x[1, i-1] - 2*k1*x[1, i-2])
        x[1, i] = k3*((k2 + 2)*x[1, i-1] + (k1**2 - 1)*x[1, i-2] - (k2 + 2)*k1*x[0, i-1] + 2*k1*x[0, i-2])
        x[2, i] = (2- 2*k2)*x[2, i-1] - x[2, i-2]
    else:
        x[:, i] = x[:, i-1] + [(j * h) for j in v[:, i-1]]

#This equation is just for calculating the acceleration and velocity of the particle, can just uncomment and plot the graph if want to 
#see the graph of the velocity 
#for i in range(1, timestep):
#    v[:, i] = v[:, i-1] + [(j * h) for j in a[:, i-1]]
#    a[0, i] = (q*V/(2*m*(d**2)))*x[0, i] + q*v[1, i]*B
#    a[1, i] = (q*V/(2*m*(d**2)))*x[1, i] - q*v[0, i]*B
#    a[2, i] = -(q*V/(m*(d**2)))*x[2, i]

#Animation
def update_lines(num, dataLines, lines):
    for line, data in zip(lines, dataLines):
        line.set_data(data[0:2, :num])
        line.set_3d_properties(data[2, :num])
    return lines

fig = plt.figure()
ax = p3.Axes3D(fig)

data = [x]
lines = [ax.plot(dat[0, 0:1], dat[1, 0:1], dat[2, 0:1])[0] for dat in data]

ax.set_xlim3d([-1, 1])
ax.set_xlabel('X')

ax.set_ylim3d([-1, 1])
ax.set_ylabel('Y')

ax.set_zlim3d([-1, 1])
ax.set_zlabel('Z')

ax.set_title('Penning Trap Simulation')

#ax.plot(x[0, :],x[1, :],x[2, :])
#Creating the Animation object
line_ani = animation.FuncAnimation(fig, update_lines, timestep, fargs=(data, lines),\
                                   interval=1, blit=False)

plt.show()
