// This file describes the quadrupole potential and related functions

function quadrupolePotential(initVoltage,position,dsqrd){
    const cylin=getCylindricalCoords(position);
    const r=cylin[0];
    const theta=cylin[1];
    const z=cylin[2];
    return initVoltage*(Math.pow(z,2)-0.5*Math.pow(r,2))/(2*dsqrd);
}

// Function to obtain the quadrupole electric field
function quadrupoleEField(initVoltage,position,dsqrd){
    const cylin=getCylindricalCoords(position);
    const r=cylin[0];
    const theta = cylin[1];
    const z=cylin[2];
    
    // The electric field formula is then given by -V0/2([-r,0,2z])
    let Ecylin = vecScalMultiply([-r,0,2*z],-initVoltage/(2*dsqrd));
    Ecylin[1] = theta;

    // We insert theta back into the equation to split r back into x and y coordinates.
    return fromCylinToCartesian(Ecylin);
}
