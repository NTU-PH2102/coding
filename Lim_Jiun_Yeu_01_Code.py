# -*- coding: utf-8 -*-
"""
Created on Tue Apr 10 17:43:34 2018

@author: limj0187
"""
import math
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from mpl_toolkits.mplot3d import axes3d, Axes3D

#initialised variables
mass = 0
charge = 0
velocity = 0
magnetotron_radius = 0
magnetotron_theta = 0
magnetotron_omega = 0
z = 0
z_omega = 0
cyclotron_radius = 0
cyclotron_theta = 0
cyclotron_omega = 0

#User Defined Variables
mass = 1
charge = 1

#initial magnetic field in the z direction given
magnetic_field = 1

#initial electric potential given
electric_potential = 10

#characteristic trap dimension given
trap_dimension = 10

#Give the particle an initial velocity in the x direction
velocity = 1

#calucluated electric field
electric_field = (1/2)*(mass/charge)*(z_omega**2)*(magnetotron_radius)

#angular frequency of oscillation in the z direction
z_omega = math.sqrt((charge*electric_potential)/(mass*(trap_dimension**2)))

#magnetotron motion
magnetotron_radius = (mass*(velocity))/(magnetic_field*charge)
magnetotron_omega = (velocity) / magnetotron_radius 

#cyclotron motion
cyclotron_omega = (z_omega**2)/(2*magnetotron_omega)
cyclotron_radius = (velocity)/cyclotron_omega 

#in order to calculate the x and y position for the particle, 
#there is a need to to calculate the influences of both the the magnetotron 
#as well as the cyclotron.
def x_position(radius,theta,cyclotron_radius,cyclotron_theta):
    return radius*math.cos(theta)+(cyclotron_radius*math.cos(cyclotron_theta))
def y_position(radius,theta,cyclotron_radius,cyclotron_theta):
    return radius*math.sin(theta)+(cyclotron_radius*math.sin(cyclotron_theta))

#calculate the z position from its angular frequency
def z_position(amplitude, t):
    return amplitude*math.cos(z_omega*t)

#animation
fig = plt.figure()
ax = plt.subplot(111,projection = '3d')

def animate(i):
    t = i*(5*10**-1) #time interval between each point where the particle is shown
    xs = x_position(magnetotron_radius,magnetotron_theta+(magnetotron_omega*t),cyclotron_radius,cyclotron_theta+(cyclotron_omega*t))
    ys = y_position(magnetotron_radius,magnetotron_theta+(magnetotron_omega*t),cyclotron_radius,cyclotron_theta+(cyclotron_omega*t))
    zs = z_position(1,t)
    return ax.scatter(xs,ys,zs)

anim = animation.FuncAnimation(fig,animate,frames = 1000, save_count = 1000)
plt.show()

#this portion is for saving the animation into an mp4 file.

#writer = animation.FFMpegWriter()
#anim.save('mymovie3.mp4',writer)