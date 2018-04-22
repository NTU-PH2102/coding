import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import matplotlib.animation as animation


# Defining constants
x0_position = 0.001  # Initial x position (m)
y0_position = 0.001  # Initial y position (m)
z0_position = 0.001  # Initial z position (m)
x0_velocity = 300.0  # Initial x velocity (m/s)
y0_velocity = 400.0  # Initial y velocity (m/s)
z0_velocity = 50.0  # Initial z velocity (m/s)
q = 1.602176565 * 10**-19  # Charge of particle (C)
m = 1.411458082 * 10**-25  # Cass of particle (kg)
B0 = 3.7  # Magnitude of the uniform magnetic field in z-direction (T)
V0 = 35.75  # Voltage between ring electrodes and end caps (V)
d = 0.01121  # Characteristic trap dimension (m)


# Frequencies
omega_c = q * B0 * (1/m)  # Cyclotron frequency (rad/s)
omega_z = np.sqrt(q * V0 * (1/m) * (1/d**2))  # axial frequency (rad/s)
omega_plus = 0.5 * (omega_c + np.sqrt(omega_c**2 - (2 * (omega_z**2))))  # Reduced cyclotron frequency (rad/s)
omega_minus = 0.5 * (omega_c - np.sqrt(omega_c**2 - (2 * (omega_z**2))))  # Magnetron frequency (rad/s)

# Amplitudes
r_plus = np.sqrt((((q/abs(q))*y0_velocity + omega_minus*x0_position)**2 + (x0_velocity - (q/abs(q))*omega_minus*y0_position)**2) /((omega_minus - omega_plus)**2))  # Amplitude of cyclotron motion (m)
r_minus = np.sqrt((((q/abs(q))*y0_velocity + omega_plus*x0_position)**2 + (x0_velocity - (q/abs(q))*omega_plus*y0_position)**2) /((omega_plus - omega_minus)**2))  # Amplitude of magnetron drift around trap centre (m)
r_z = np.sqrt(z0_position**2 + (z0_velocity**2)/(omega_z**2))  # Amplitude of axial motion

# Phase constants
phi_plus = np.arccos(((q/abs(q))*y0_velocity + omega_minus*x0_position) / (r_plus*(omega_minus - omega_plus)))  # Phase constant for reduced cyclotron frequency
phi_minus = np.arccos(((q/abs(q))*y0_velocity + omega_plus*x0_position) / (r_minus*(omega_plus - omega_minus)))  # Phase constant for magnetron frequency
phi_z = np.arccos(z0_position/r_z)  # Phase constant for axial frequency


def x(time):
    """Returns x-coordinate position of particle
       Keyword arguments:
           time -- the time at which the x-coordinate of the particle is desired
    """
    result = r_plus * np.cos(omega_plus * time + phi_plus) + r_minus * np.cos(omega_minus * time + phi_minus)
    return result


def y(time):
    """Returns y-coordinate position of particle
           Keyword arguments:
               time -- the time at which the y-coordinate of the particle is desired
    """
    result = r_plus * np.sin(omega_plus * time + phi_plus) + r_minus * np.sin(omega_minus * time + phi_minus)
    return result


def z(time):
    """Returns z-coordinate position of particle
           Keyword arguments:
               time -- the time at which the z-coordinate of the particle is desired
    """
    result = r_z * np.cos(omega_z * time + phi_z)
    return result


def update_lines(n, dataLines, lines):
    for line, dat in zip(lines, dataLines):
        line.set_data(dat[0:2, :n])
        line.set_3d_properties(dat[2, :n])
    return lines


# Generate data
step = 2 * np.pi * 1/omega_plus * 1/45  # Ensures that the time divisions are sufficiently small to generate trajectory of cyclotron motion
cycles = 10  # Number of magnetron cycles
n = int(np.ceil(2 * np.pi * 1/omega_minus * cycles * 1/step))  # Number of data points
data = np.empty((3, n))
for i in range(0, n):
    t = i * step  # time
    data[0, i] = x(t)
    data[1, i] = y(t)
    data[2, i] = z(t)
data = [data]

# Attaching 3D axis to the figure
fig = plt.figure()
ax = p3.Axes3D(fig)

# Viewing position
ax.elev = 35.
ax.azim = 150.
ax.dist = 11.

lines = [ax.plot(dat[0, 0:1], dat[1, 0:1], dat[2, 0:1], color='#3498DB',  linewidth=1)[0] for dat in data]

# Setting the axes properties
ax.set_xlim3d([-1.25 * r_minus, 1.25 * r_minus])
ax.set_xlabel('X')

ax.set_ylim3d([-1.25 * r_minus, 1.25 * r_minus])
ax.set_ylabel('Y')

ax.set_zlim3d([-1.25 * r_z, 1.25 * r_z])
ax.set_zlabel('Z')

ax.set_title('Charged Particle Motion in Penning Trap')

# Creating the Animation object
line_ani = animation.FuncAnimation(fig, update_lines, n, fargs=(data, lines),
                                   interval=1, blit=True)
plt.show()
