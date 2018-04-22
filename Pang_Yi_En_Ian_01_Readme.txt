Readme file for Penning Trap code:

1) Open the file "Pang_Yi_En_Ian_02_matlab_code.m"

2) Run the script and it should output two figures. Figure 1 is the plot of the combined trajectory of the particle in the Penning Trap after the stated number of time steps (the default number of time steps is 1000). Figure 2 is the animation of the particle's trajectory in the Penning Trap.

3) The trajectory of the particle in the Penning Trap is sensitive to the magnitude of the chosen parameters in the code.

4) There are 13 parameters that be adjusted to obtain a different trajectory from the default one:

	a. q - particle charge (in Coulombs) ---------- line 5
	b. m - particle mass (in kilograms) ---------- line 6
	c. rho0 - minimum radial distance of particle to trap electrodes (in metres) ---------- line 7
	d. z0 - minimum axial distance of particle to trap electrodes (in metres) ---------- line 8
	e. V0 - potential constant in Penning trap (in Volts) ---------- line 11
	f. B0 - magnitude of uniform magnetic field in Penning trap (in Tesla) ---------- line 12
	g. x(1) - initial x-position of particle (in metres) ---------- line 21
	h. y(1) - initial y-position of particle (in metres) ---------- line 21
	i. z(1) - initial z-position of particle (in metres) ---------- line 21
	j. vx - initial x-velocity of particle (in metres per second) ---------- line 23
	k. vy - initial y-velocity of particle (in metres per second) ---------- line 23
	l. vz - initial z-velocity of particle (in metres per second) ---------- line 23
	m. h - length of discrete time step (in seconds) ---------- line 19

5) Note that a large value of h may not produce the expected trajectory of particle in a Penning Trap.