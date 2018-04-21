// Main file to execute animation

// Defining dataset/variables
const data ={
    VoltageSupp : 10,
    position : [0,0,0],
    velocity : [10*Math.pow(10,0),10*Math.pow(10,0),0.5],
    accel : [0,0,0],
    bFieldStr : 5*Math.pow(10,0),
    endcap : 15,
    ring : 15,
    mass : 1.67,
    charge : 1.6,
}

let particle = new Particle(data);
const bField = [0,0,data.bFieldStr];
const endcap = data.endcap;
const ring = data.ring;

// Getting d^2, the characteristic trap dimension
const dsqrd = 0.5*(Math.pow(endcap,2)+0.5*Math.pow(ring,2));
particle.dsqrd = dsqrd;


// Setting up the animation overlay parameters
let scene = new THREE.Scene();
let camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000 );

let renderer = new THREE.WebGLRenderer();
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );


// Setting up the particle
let geometry = new THREE.SphereGeometry(0.5, 50, 50, 0, Math.PI * 2, 0, Math.PI * 2);
let material = new THREE.MeshNormalMaterial();
let sphere = new THREE.Mesh( geometry, material );
scene.add( sphere );

// Setting up particle trajectory, courtesy https://stackoverflow.com/questions/18370701/how-to-draw-the-trajectory-of-a-mesh-with-threejs
let markSize = 0.05; 
let markGeom = new THREE.BoxGeometry(markSize, markSize, markSize, 1, 1, 1);
let markMat = new THREE.MeshBasicMaterial({color: "blue"});

// Use a counter to keep track of the time, to update parameters
let counter = 0;

// Initialize camera
camera.position.set( -5, 5, 15 );
camera.lookAt( scene.position );
camera.zoom;

/*
* Execute the animation loop
* requestAnimationFrame does the animation frame by frame
* Since default FPS is 60, we adjust the time interval accordingly
*/ 
function animate() {
    requestAnimationFrame( animate );

    counter++;

    // Every 10 frames, or 1/6 of a second, we add a marker
    if (counter % 10 === 0){

        // Add a marker to signify the trajectory of the particle
        let marker = new THREE.Mesh(markGeom.clone(), markMat);
        marker.position.copy(sphere.position);
        scene.add(marker);
        marker.name = counter;
        
        /** 
         * After 2400 frames or 240 markers, we begin to remove markers to save computing power
         * The markers are removed starting from the first, and every 10 frames
         * Courtesy https://stackoverflow.com/questions/39322054/three-js-remove-specific-object-from-scene
        */
        if (counter >= 2400){
            remove(counter-2400);
        }
    }

    // Every sixty frames (or one second), run the following lines
    if (counter%60 === 0){

        // Update the particle's position, velocity and Lorentz force values on the html page
        document.getElementById("p1").innerHTML = round(particle.position[0],2);
        document.getElementById("p2").innerHTML = round(particle.position[1],2);
        document.getElementById("p3").innerHTML = round(particle.position[2],2);

        document.getElementById("v1").innerHTML = round(particle.velocity[0],2);
        document.getElementById("v2").innerHTML = round(particle.velocity[1],2);
        document.getElementById("v3").innerHTML = round(particle.velocity[2],2);

        let lorentzForce = particle.calcLorentzForce(quadrupoleEField(particle.initVoltage, 
            particle.position, particle.dsqrd), bField, particle.velocity);
        document.getElementById("L1").innerHTML = round(lorentzForce[0],2);
        document.getElementById("L2").innerHTML = round(lorentzForce[1],2);
        document.getElementById("L3").innerHTML = round(lorentzForce[2],2);
    }

    /* 
    * To increase the accuracy of our simulation, for every frame, or 1/60 of a second, we simulate the particle's motion
    * for 10 intervals, so 1/600th of a second for 10 times.
    */
    for (let i=0; i<10; i++){
        particle.updateParameters(1/600,bField);
    }
        
    // Finally, we update the particle and render it on screen.
    // We swap the y and z position of the particle because of how it appears on screen
    sphere.position.set(particle.position[0], particle.position[2], particle.position[1]);
    renderer.render( scene, camera );
}
// For now, we have 60 frames and 600 computations of kinematic variables per second.
animate();
