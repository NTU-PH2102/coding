1) Open the file "Lee_Jia_Jie_Benedict_02_matlab_code.m".
2) The code should run as it is.
3) To modify the code, change the parameters at the top of the code. Things can be change are: size of the trap, initial position, x0, initial velocity, v0, charge,q, mass,m, B field, B, as well as the potential,V0. 
4) To change the Electric field, change the function at the "efield" function.
5) IMPT: there are no checks in the code. Ensure that the parameters entered are physical!!!

6) There are some optional things which can be changed. 

7)You can plot the E field in the graph, to do that, un-comment "plote".

8)Change the axis size. The axis is default to be the same size as the trajectory. To change that, go to the line "axis[[xmin xmax],[ymin ymax],[zmin zmax]]" and change the vector inside.

9) To change the speed of the animation. Change the "rate" variable.

10) To output the plot without the animation, comment out the plotting part of the code (refer to explanatory notes) and un-comment the "plot3".

11) Time step and time interval can be changed. However, do note that the speed of oscillation for this system is rather large. Keeping the time step small is recommended. 

12) This code outputs any trajectory in any E or B field specified, not just one found in a Penning Trap.