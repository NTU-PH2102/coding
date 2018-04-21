// This file describes a user-defined particle and its associated functions.

// Initializing variables
function Particle(data){
    this.mass = 0;
    this.charge = 0;
    this.position = [0,0,0];
    this.accel = [0,0,0];
    this.velocity = [0,0,0];
    this.initVoltage = 0;
    this.dsqrd = 0;
    
    if (!!data){
        // Fill with data if present
        this.mass = data.mass;
        this.charge = data.charge;
        this.position = data.position;
        this.accel = data.accel;
        this.velocity = data.velocity;
        this.initVoltage = data.VoltageSupp;
    }
};

// Updating of particle parameters at the end of a time-based loop
// Simplification of resultant force to Lorentz force
Particle.prototype.updateParameters = function(timeInterval = 1, bField = [0,0,0]){
    const eField = quadrupoleEField(this.initVoltage,this.position,this.dsqrd);

    // a = F/m
    this.accel = vecScalDiv(this.calcLorentzForce(eField,bField,this.velocity),this.mass);
    this.updateVelocity(timeInterval,bField);
    this.updatePosition(timeInterval,bField);
}


// To calculate Lorentz force, we follow the equation F=q(vxB + E)
Particle.prototype.calcLorentzForce = function(eField = [0,0,0], bField = [0,0,0],v = this.velocity){
    const vxB = crossProduct(v,bField);
    // Following the equation, F = q(vxB + E)
    return vecScalMultiply(vecAdd(vxB,eField),this.charge);
}

/** 
 * The 4th order Runge-Kutta method is a numerical analysis method  
 * We use it to obtain a more accurate value of a quantity in the next time interval
 * Courtesy of https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods
 * 
 * Suppose we have an initial value problem dy/dt = f(t,y), y(t0)=y0
 * Then, at point n+1, y(n+1) would be given by y(n) + h/6((k1 + 2k2 + 2k3 + k4)
 * where t(n+1) = t(n) + h, where h is the time interval
 * 
 * k1 = f(t(n),y(n)) , the current derivative
 * k2 = f(t(n) + h/2, y(n) + 0.5hk1), the derivative at the midpoint of h
 * k3 = f(t(n) + h/2, y(n) + 0.5hk2), the derivaive right after the midpoint of h
 * k4 = f(t(n) +h, y(n) + hk3), the derivative at the tail-end of the interval
 * 
 * This lets us construct a sort of trapezoid to shape the evolution of y
*/


Particle.prototype.updateVelocity = function(timeInterval = 1, bField = [0,0,0]){

    // We use the 4th order Runge-Kutta method to calculate the next velocity in a time interval h
    const k1 = this.accel;
    const k2 = this.getNextAccel(timeInterval/2,bField,k1);
    const k3 = this.getNextAccel(timeInterval/2,bField,k2);
    const k4 = this.getNextAccel(timeInterval,bField,k3);

    // y(n+1) = y(n) + h/6(k1 + 2k2 + 2k3 + k4)
    this.velocity = this.velocity.map(function(value,index){
        return value + timeInterval/6*(k1[index] + 2*k2[index] + 2*k3[index] +k4[index]);
    });
}

Particle.prototype.updatePosition = function(timeInterval = 1, bField = [0,0,0]){

    // We use the 4th order Runge-Kutta method to calculate the next position in a time interval h
    const k1 = this.velocity;
    const k2 = this.getNextVelocity(timeInterval/2,bField,k1);
    const k3 = this.getNextVelocity(timeInterval/2,bField,k2);
    const k4 = this.getNextVelocity(timeInterval,bField,k3);

    // y(n+1) = y(n) + h/6(k1 + 2k2 + 2k3 + k4)
    this.position = this.position.map(function(value,index){
        return value + timeInterval/6*(k1[index] + 2*k2[index] + 2*k3[index] +k4[index]);
    });
}
Particle.prototype.getNextAccel = function(timeInterval = 1, bField = [0,0,0], k){

    // Use Euler's method to get the next t_n + h particle parameters
    const velocity = vecAdd(this.velocity,vecScalMultiply(k,timeInterval));
    const position = vecAdd(this.position,vecScalMultiply(velocity,timeInterval));

    // Using t_n + h parameters to find acceleration
    const eField = quadrupoleEField(this.initVoltage,position,this.dsqrd);
    return vecScalDiv(this.calcLorentzForce(eField,bField,velocity),this.mass)
}

Particle.prototype.getNextVelocity = function(timeInterval = 1, bField = [0,0,0], k){

    // Use Euler's method to get the next t_n + h particle parameters
    const position = vecAdd(this.position,vecScalMultiply(k,timeInterval));
    const eField = quadrupoleEField(this.initVoltage,position,this.dsqrd);
    const accel = vecScalDiv(this.calcLorentzForce(eField,bField,this.velocity),this.mass);

    // Use t_n + h parameters to find velocity
    return vecAdd(this.velocity,vecScalMultiply(accel,timeInterval));
}
