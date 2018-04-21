// This file describes useful functions to avoid taking up space in the main file.

// Cross-product function
function crossProduct(a,b){
    return [ a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0] ];
}

// Element-wise addition for vectors
function vecAdd(a,b){
    if (a.length != b.length) return 0;
    return a.map(function(element,index){
        return element+b[index];
    });
}

// Function to multiply a vector by a scalar
function vecScalMultiply(a,scalar=1){
    return a.map(function(element,index){
        return element*scalar || 0;
    });
}

// Function to divide a vector by a scalar
function vecScalDiv(a,scalar=1){
    return a.map(function(element,index){
        return element/scalar || 0;
    });
}

// Function to convert cartesian coordinates to cylindrical coordinates
function getCylindricalCoords(position=[0,0,0]){
    const x = position[0] || 0;
    const y = position[1] || 0;
    const z = position[2] || 0;
    return [Math.sqrt(Math.pow(x,2)+Math.pow(y,2) || 0), Math.atan2(y, x) || 0, z];
}

// Function to normalize a vector, optional argument to specify dimensions
function norm(vector,x=3){
    vector = vector.slice(0,x-1);
    return Math.sqrt(vector.reduce((a,b) =>
        a+Math.pow(b,2),0));
}

// Function to convert cylindrical coordinates to cartesian coordinates
function fromCylinToCartesian(a){
    const r = a[0];
    const theta = a[1];
    const z = a[2];
    return [r*Math.cos(theta),r*Math.sin(theta),z];
}

// Rounding function, courtesy https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/round
function round(number, precision) {
    var shift = function (number, precision, reverseShift) {
      if (reverseShift) {
        precision = -precision;
      }
      var numArray = ("" + number).split("e");
      return +(numArray[0] + "e" + (numArray[1] ? (+numArray[1] + precision) : precision));
    };
    return shift(Math.round(shift(number, precision, false)), precision, true);
  }
  
  // Removes marker from the scene
  function remove(id) {
    scene.remove(scene.getObjectByName(id));
  }
