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

#Timestep is the number of iteration that the animation will do
timestep = 10000

#Initial conditions
x0 = 0
y0 = 0
z0 = 0
vx0 = 8*10**7
vy0 = 8*10**7
vz0 = 8*10**7
ax0 = (q*V/(2*m*(d**2)))*x0 + q*vy0*B
ay0 = (q*V/(2*m*(d**2)))*y0 - q*vx0*B
az0 = -(q*V/(2*m*(d**2)))*z0

#Initializing variables
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

for i in range(1, timestep):
    v[:, i] = v[:, i-1] + [(j * h) for j in a[:, i-1]]
    a[0, i] = (q*V/(2*m*(d**2)))*x[0, i] + q*v[1, i]*B
    a[1, i] = (q*V/(2*m*(d**2)))*x[1, i] - q*v[0, i]*B
    a[2, i] = -(q*V/(m*(d**2)))*x[2, i]

#Animation
def update_lines(num, dataLines, lines):
    for line, data in zip(lines, dataLines):
        line.set_data(data[0:2, :num])
        line.set_3d_properties(data[2, :num])
    return lines

fig_x = plt.figure()
ax_x = p3.Axes3D(fig_x)
ax_x.get_autoscale_on()

fig_v = plt.figure()
ax_v = p3.Axes3D(fig_v)
ax_v.get_autoscale_on()

fig_a = plt.figure()
ax_a = p3.Axes3D(fig_a)
ax_a.get_autoscale_on()

data_x = [x]
data_v = [v]
data_a = [a]

#Draw lines in between every points in the data
lines_x = [ax_x.plot(dat[0, 0:1], dat[1, 0:1], dat[2, 0:1], lw = 3)[0] for dat in data_x]
lines_v = [ax_v.plot(dat[0, 0:1], dat[1, 0:1], dat[2, 0:1], lw = 3)[0] for dat in data_v]
lines_a = [ax_a.plot(dat[0, 0:1], dat[1, 0:1], dat[2, 0:1], lw = 3)[0] for dat in data_a]

#Lines below are for labelling the axes
ax_x.set_xlabel('X')
ax_v.set_xlabel('X')
ax_a.set_xlabel('X')

ax_x.set_ylabel('Y')
ax_v.set_ylabel('Y')
ax_a.set_ylabel('Y')

ax_x.set_zlabel('Z')
ax_v.set_zlabel('Z')
ax_a.set_zlabel('Z')

#Plot title
ax_x.set_title('Penning Trap Simulation - Position')
ax_v.set_title('Penning Trap Simulation - Velocity')
ax_a.set_title('Penning Trap Simulation - Acceleration')

#Creating the animation object for position
plt.figure(1)
line_ani_x = animation.FuncAnimation(fig_x, update_lines, timestep, fargs=(data_x, lines_x),\
                                   interval=1, blit=False)
#Plotting the whole particle trajectories without animation
plt.figure(1)
ax_x.plot(x[0, :],x[1, :],x[2, :], lw=0.5, color='green')
plt.show()

#Creating animation object for velocity
plt.figure(2)
line_ani_v = animation.FuncAnimation(fig_v, update_lines, timestep, fargs=(data_v, lines_v),\
                                   interval=1, blit=False)
#Plotting the whole trace of the particle's velocity throughout the simulation
plt.figure(2)
ax_v.plot(v[0, :],v[1, :],v[2, :], lw=0.5, color='orange')
plt.show()

#Creating animation object for acceleration
plt.figure(3)
line_ani_a = animation.FuncAnimation(fig_a, update_lines, timestep, fargs=(data_a, lines_a),\
                                   interval=1, blit=False)
#Plotting the whole trace of the particle's acceleration throughout the simulation
plt.figure(3)
ax_a.plot(a[0, :],a[1, :],a[2, :], lw=0.5, color='red')
plt.show()