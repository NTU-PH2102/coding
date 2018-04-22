// =================================== //
//  NOTE: PERMUTATION OF COORDINATES   //
// =================================== //
/*
  For whatever reason, the orbitControls I'm using
  here restrains rotation in the y-axis instead of
  the z-axis (so you can rotate the x-z plane as
  much as you'd like, but you won't be able to rotate
  over the y-axis). Which is weird because this
  rotation lock is usually to lock the rotation across
  the z-axis.

  Hence, to preserve the intuitive behaviour, I have
  switched the coordinates as follows:
      [x, y, z] -> [z, x, y]

  So if my particle is at 10m along the z direction,
  I will draw it at 10m along the y direction instead.

  Here the handedness of the coordinates is still
  preserved, and all the guides have been switched
  accordingly (so this switch in coordinate would
  not affect the front-end whatsoever)
*/

// ============================ //
//  The Penning Trap Simulator  //
// ============================ //
/*
           Contents

    0. Settings
    1. Environment setup
      1.0  Renderer, camera and controls
      1.1  Lights
      1.2  Grid lines
    2. Object initialisation
      2.0  Particle
      2.1  History trail
      2.2  "Cage"
      2.3  Force arrows
    3. Animation loop

*/
// ============================ //


// ============== //
//  0. Settings   //
// ============== //
var historyPoints = 1200  // Number of points of the history "tail"


// ======================= //
//  1. Environment setup   //
// ======================= //

console.warn = function() {} // This quietens the warning when the length of the
                             // arrow goes to 0 and it cannot find the determinant

var scene    = new THREE.Scene,
    camera   = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 20000),
    renderer = new THREE.WebGLRenderer({antialias: true}),
    controls = new THREE.OrbitControls(camera, document.getElementById("animation"))


// ======================================= //
//  1.0  Renderer, camera and controls     //
// ======================================= //

// Adding the render elements into the documents,
// plus other miscellaneous initialisations. Most
// of the settings are pretty clear from their names.
renderer.setPixelRatio(window.devicePixelRatio)
renderer.setSize(window.innerWidth, window.innerHeight)
renderer.setClearColor(0x000000, 1)
document.getElementById("animation").appendChild(renderer.domElement)

camera.position.set(10, 6, 20)
camera.rotation.x = .5

controls.rotateSpeed = 5.0
controls.zoomSpeed = 3.2
controls.panSpeed = 0.8
controls.enableZoom = true
controls.update()


// ================ //
//  1.1  Lights     //
// ================ //

// Here we add a basic three-point lighting.
// Basically just three lights to make the particle
// look nice and also bring out the 3D effect.
var lights = []
for (let i=0; i<3; i++) {
  lights[i] = new THREE.SpotLight(0xffffff, 1, 0)
  scene.add(lights[i])
}

// No reason for the positions of the lights
//  except that they look decent
lights[0].position.set(0, 1000, 0)
lights[1].position.set(100, 1000, 100)
lights[2].position.set(-100, -200, -100)

// ===================== //
//  1.2  Grid lines      //
// ===================== //

// The grid utilises the labelAxis() function written by Sue Lockwood
// https://github.com/deathbearbrown/learning-three-js-blogpost
// which in turn uses the makeTextSprite() function by Lee Stemkoski
// https://stemkoski.github.io/Three.js/Sprite-Text-Labels.html

// Mostly self explanatory
var gridObjectGroup  = new THREE.Group, // Group all the grid objects together
    gridSize      = 100,                // so we can toggle it
    gridDivisions = 20,
    gridColours   = [0x332222, 0x223022, 0x222238], // Here we use muted version of
                                                   // the colour scheme xyz <-> RGB
    gridHelper    = []

// Now we add the grids for each x, y, and z
for (let i=0; i<3; i++) {
  gridHelper.push(new THREE.GridHelper(gridSize, gridDivisions, gridColours[i], gridColours[i]))
  gridObjectGroup.add(gridHelper[i])
}
scene.add(gridObjectGroup)

// Rotate the y-grid and z-grid into position
gridHelper[1].rotation.x =
gridHelper[2].rotation.z = Math.PI/2

// Create the grid labels, centred around 0
//
//  (i/gridDivisions)  gives the "progress" along the entire grid.
//                     that is, it starts from -0.5 at the negative
//                     end and ends at 0.5 at the positive end
//
//     * gridSize      scales the above up to the size of the grid
//
//  /particle.scale.x  scales the labels down to the scale of the grid
//                     e.g. if the scale is 1e12, so 1 unit of the grid
//                     should be is 1e-12m, so this divides it by 1e-12
//
//   .toPrecision(1)   here particle.scale.x should have been chosen
//                     such that dividing by it gives a whole number,
//                     but either way we round it to 1.s.f. so that
//                     it appears nicely on the grid
//
var gridLabels       = [],
    gridLabelObjects = [],
    gridLabelGroup  = new THREE.Group

for (let i=-gridDivisions/2; i <= gridDivisions/2; i++)
  gridLabels.push( ( (i/gridDivisions) * gridSize /particle.scale.x ).toPrecision(1) )

for (let i=0; i<3; i++) {
  gridLabelObjects.push(
    labelAxis(
      (gridSize + gridSize/gridDivisions)/2,      // Increase the grid by one
                                                  // division to include "0"

      i == 1 ? gridLabels : gridLabels.reverse(), // The grid labels go the
                                                  // wrong way for the y-axis
                                                  // so we add it in in reverse

      ["z", "x", "y"][i]                          // This has to do with the orbit
                                                  // control limits, see above
    )
  )
  gridLabelGroup.add(gridLabelObjects[i])
}

// Shift the positions of the grids accordingly
// to centre it around the origin
gridLabelObjects[0].position.z =
gridLabelObjects[1].position.x =  gridSize/2
gridLabelObjects[2].position.y = -gridSize/2

scene.add(gridLabelGroup)

// Here we add an axis helper with size
// half a division of the grid and
// colour scheme xyz <-> RGB
var axisHelper = new THREE.AxesHelper(gridSize/gridDivisions/2)

// Orbit control limit fix
axisHelper.rotation.x =
axisHelper.rotation.z = -Math.PI/2

scene.add(axisHelper)


// =========================== //
//  2. Object initialisation   //
// =========================== //


// ================== //
//  2.0  Particle     //
// ================== //

var particleGeometry = new THREE.SphereGeometry(.5), // Basically we model the
                                                     // particle as a sphere

    particleMaterial = new THREE.MeshPhongMaterial({
                         color: 0xAAAAAA,
                         emissive: 0x000000,         // Make it grey
                         side: THREE.DoubleSide
                       }),
    particleObject   = new THREE.Mesh(particleGeometry, particleMaterial)

scene.add(particleObject)


// ======================= //
//  2.1  History trail     //
// ======================= //

// The "tails" that shows the history of the path taken.
//   tails[0] is the history of the position,
//   tails[1] is the history of the magnetic force,
//   tails[2] is the history of the electric force
//
var forceGroup      = new THREE.Group()
    tails           = [],
    tailGeometry    = [],
    tailPoints      = (
                        new THREE.CatmullRomCurve3([     // First we create a set of
                          new THREE.Vector3(0,0,0),      // dummy points so that we
                          new THREE.Vector3(1,0,0)       // can fill it in later
                        ], false, "catmullrom")
                      ).getPoints(historyPoints)
    tailBaseColours = [0xFFFFFF, 0xEEBB00, 0X22CCCC],    // White, Orange, Cyan
    tailColours     = [],
    tweenFactor     = 1.5,                               // How quickly we want
                                                         // the tails to disappear
    tailMaterial   = new THREE.LineBasicMaterial({
                        transparent: true,               // Make the line follow
                        opacity: .75,                    // the colour we define
                        vertexColors: THREE.VertexColors // at each point
                      })

// Now we go through the number of "tails"
// there are:
//    1 for the position,
//    tailWidth for the magnetic force,
//    tailWidth for the electric force
for (let i=0; i<1+2*10; i++) {

  // We initialise a lineGeometry, and an empty array that will contain the colours
  tailGeometry.push(new THREE.BufferGeometry().setFromPoints(tailPoints))
  tailColours.push(new Float32Array( (historyPoints+1) * 3 ))

  // Beginning with the colours we defined as the "base colours",
  // it shall slowly fade to black to give the illusion of the tail
  // fading out
  let colour = new THREE.Color(tailBaseColours[i == 0 ? 0:((i+1)%2+1)]),
      theHSL = colour.getHSL({})

  for (let j=0, l=historyPoints+1; j<l; j++) {
    // To do that, we scale the lightness (1 is white, 0 is black)
    // of the colour down gradually, making sure the scaling
    // factor is maximum 1: or, the maximum lightness the colours
    // should have is the lightness of the base colour above
    let currentScale = (Math.exp(tweenFactor*(1-j/l))-1)
    currentScale = currentScale > 1 ? 1:currentScale
    colour.setHSL(theHSL.h, theHSL.s, theHSL.l*currentScale)

    tailColours[i][j*3    ] = colour.r
    tailColours[i][j*3 + 1] = colour.g
    tailColours[i][j*3 + 2] = colour.b
  }

  // Now set the gradually fading out colours into the
  // attribute of the line and add it into the scene
  tailGeometry[i].addAttribute('color', new THREE.BufferAttribute(tailColours[i], 3))
  tails.push(new THREE.Line(tailGeometry[i], (i ==0 ? tailMaterial:tailMaterial.clone())))
  if (i == 0) {
    scene.add(tails[i])
  } else {
    tails[i].material.transparent = true
    if (i <= 2*(opt.tailWidth || 0)) {
      tails[i].material.opacity *= (1-(Math.ceil(i/2)-1)/opt.tailWidth)
      forceGroup.add(tails[i])
    }
  }
}
scene.add(forceGroup)



// ================ //
//  2.2  "Cage"     //
// ================ //

// Define a cylinder that is made out of the maximum possible
// coordinates (so, twice the amplitude of the position function)
var cageGeometry = new THREE.CylinderGeometry(
                       particle.caps[0]*particle.scale.x + 1, // These are radiuses so
                       particle.caps[1]*particle.scale.x + 1, // there's no need to *2
                     2*particle.caps[2]*particle.scale.x + 1,
                   16, 8, true),
    cageMaterial = new THREE.MeshLambertMaterial({
                     color: 0xFFFFFF,
                     transparent: true,
                     opacity: .5,
                     side: THREE.DoubleSide
                   }),
    cage         = new THREE.Mesh(cageGeometry, cageMaterial)
scene.add(cage)


// ====================== //
//  2.3  Force arrows     //
// ====================== //

// For now these are just dummy arrows, the length and
// direction will be only set within the animation loop
var forceDirection = {
      B: new THREE.Vector3(1,0,0),
      E: new THREE.Vector3(1,0,0)
    }
    forceArrows    = {
      B: new THREE.ArrowHelper(forceDirection.B, new THREE.Vector3, .5, 0xEEBB00, .5, .25),
      E: new THREE.ArrowHelper(forceDirection.E, new THREE.Vector3, .5, 0X22CCCC, .5, .25)
    }
scene.add(forceArrows.B)
scene.add(forceArrows.E)


// ==================== //
//  3. Animation loop   //
// ==================== //

var t0        = null, // Initialise the variable for the start time
    animation = function(t1) {
      // If there is no start time, now is the start time.
      if (t0 == null)
        t0 = t1

      // Here a value has been changed by the user, so we update it
      if (typeof doUpdateNow != "undefined" && doUpdateNow == true) {

        let t = (t1-t0)/1000*particle.scale.t*( opt.customSpeed || 1 )
        // Check for the type of update
        for (let i=0; i<doUpdate.length; i++) {
          if (doUpdate[i] == "V0") {
            particle.setV0(opt.V0, t)
          } else if (doUpdate[i] == "B0") {
            particle.setB0(opt.B0, t)
          } else if (doUpdate[i] == "d") {
            particle.setD(opt.d, t)
          } else if (doUpdate[i] == "m") {
            particle.setM(opt.m, t)
          } else if (doUpdate[i] == "q") {
            particle.setQ(opt.q, t)
          }
        }

        // Re-draw the Penning cage since the settings have changed
        scene.remove(cage)
        if (particle.stable.z && particle.stable.xy) {
          cage.geometry = new THREE.CylinderGeometry(
                                 particle.caps[0]*particle.scale.x + 1,
                                 particle.caps[1]*particle.scale.x + 1,
                               2*particle.caps[2]*particle.scale.x + 1,
                             16, 8, true)
          if (opt.showCage)
            scene.add(cage)
        }

        // Same for the grid labels
        for (let i=-gridDivisions/2; i <= gridDivisions/2; i++)
          gridLabels[i+gridDivisions/2] = ( (i/gridDivisions) * gridSize /particle.scale.x ).toPrecision(1)

        for (let i=0; i<3; i++) {
          gridLabelGroup.remove(gridLabelObjects[i])
          gridLabelObjects[i] = labelAxis(
                                  (gridSize + gridSize/gridDivisions)/2,
                                  i == 1 ? gridLabels : gridLabels.reverse(),
                                  ["z", "x", "y"][i]
                                )
          gridLabelGroup.add(gridLabelObjects[i])
        }

        document.getElementById("ohNo").style.top = (particle.stable.z && particle.stable.xy) ? "-50%":"50%"

        gridLabelObjects[0].position.z =
        gridLabelObjects[1].position.x =  gridSize/2
        gridLabelObjects[2].position.y = -gridSize/2

        // Re-initialise the settings
        opt.init(particle.V0, particle.B0, particle.d)

        // Reset all the update parameters
        doUpdate = []
        doUpdateNow = false
        t0 = t1
      }

      // This will store the points that trace our the tail
      let historicalPoints = []
      for (let k=0; k<1+2*opt.tailWidth; k++)
        historicalPoints.push([])

      // Scale the force vectors consistently, such that they
      // won't be poking out of the screen
      let FScale = Math.min(
                  particle.scale.x/particle.Osum/particle.q/particle.B0/2,
                  particle.scale.x/particle.q/particle.V0*particle.d**2/2
                )
      // Go backwards in time
      for (let i=0; i<opt.particleHistory*1000; i++) {

        // But if we go too far backwards, before the
        // intial time, then we stop going backwards
        // and exit the loop
        if (t1 - i - t0 < 0)
          break

        // Get the current position and forces.
        // FScale scales the magnitude of the force
        // so it would fit into the graph
        let x = particle.x((t1 - i - t0)/1000*particle.scale.t*( opt.customSpeed || 1 )),
            F      = particle.F((t1 - i - t0)/1000*particle.scale.t*( opt.customSpeed || 1 ))

        // If this is the current point, then move the particle to the current position
        if (i == 0) {
          particleObject.position.set(particle.scale.x*x[1], particle.scale.x*x[2], particle.scale.x*x[0])

          // And also update the force arrows
          forceDirection.B.set(F.B[1],F.B[2],F.B[0])
          forceDirection.E.set(F.E[1],F.E[2],F.E[0])
          forceArrows.B.setLength(forceDirection.B.length()*FScale, .5, .25)
          forceArrows.E.setLength(forceDirection.E.length()*FScale, .5, .25)
          forceArrows.B.setDirection(forceDirection.B.normalize())
          forceArrows.E.setDirection(forceDirection.E.normalize())
          forceArrows.B.position.set(particle.scale.x*x[1], particle.scale.x*x[2], particle.scale.x*x[0])
          forceArrows.E.position.set(particle.scale.x*x[1], particle.scale.x*x[2], particle.scale.x*x[0])

          // And also print out the positions and forces
          for (let i=0; i<3; i++) {
            document.getElementById("info"   + ["X", "Y", "Z"][i]).innerHTML =   x[i].toPrecision(3).replace("e", "&times;10<sup>") + "</sup>"
            document.getElementById("infoFB" + ["x", "y", "z"][i]).innerHTML = F.B[i].toPrecision(3).replace("e", "&times;10<sup>") + "</sup>"
            document.getElementById("infoFE" + ["x", "y", "z"][i]).innerHTML = F.E[i].toPrecision(3).replace("e", "&times;10<sup>") + "</sup>"
          }

          document.getElementById("infoSpeed").innerHTML = (particle.scale.t*( opt.customSpeed || 1 )).toPrecision(3).replace("e", "&times;10<sup>") + "</sup>"
        }

        // Push the particle position into the history
        historicalPoints[0].push(new THREE.Vector3(particle.scale.x*x[1], particle.scale.x*x[2], particle.scale.x*x[0]))
        if (typeof opt.showForceTrail == "undefined" || opt.showForceTrail == true) {
          for (let k=0; k<opt.tailWidth; k++) {
            historicalPoints[1+2*k].push(new THREE.Vector3(
              particle.scale.x*x[1] + F.B[1]*FScale*(1-k/opt.tailWidth),
              particle.scale.x*x[2] + F.B[2]*FScale*(1-k/opt.tailWidth),
              particle.scale.x*x[0] + F.B[0]*FScale*(1-k/opt.tailWidth)
            ))
            historicalPoints[2+2*k].push(new THREE.Vector3(
              particle.scale.x*x[1] + F.E[1]*FScale*(1-k/opt.tailWidth),
              particle.scale.x*x[2] + F.E[2]*FScale*(1-k/opt.tailWidth),
              particle.scale.x*x[0] + F.E[0]*FScale*(1-k/opt.tailWidth)
            ))
          }
        }
      }

      // And if we have enough points to interpolate
      // (CatMull needs at least 2), then we shall
      if (historicalPoints[0].length > 1) {
        for (let k=0; k<1+((typeof opt.showForceTrail == "undefined" || opt.showForceTrail == true) ? 2*opt.tailWidth:0); k++) {
          let points = (new THREE.CatmullRomCurve3(historicalPoints[k], false, "catmullrom")).getPoints(historyPoints)
          for (let i=0; i < points.length; i++) {
            tails[k].geometry.attributes.position.array[3*i] = points[i].x
            tails[k].geometry.attributes.position.array[3*i+1] = points[i].y
            tails[k].geometry.attributes.position.array[3*i+2] = points[i].z
          }
          tails[k].geometry.attributes.position.needsUpdate = true
        }
      }

      // Case the particle as if it were an FPS game
      if (typeof opt.chaseCamera != "undefined" && opt.chaseCamera == true) {
      	let relCamOffset = new THREE.Vector3(10, 10, 15),
            camOffset    = relCamOffset.applyMatrix4(particleObject.matrixWorld)
      	camera.position.set(camOffset.x, camOffset.y, camOffset.z)
      	camera.lookAt(particleObject.position)
      }

      // Render the scene,
      // then repeat the loop
      renderer.render(scene, camera)
      requestAnimationFrame(animation)
    }
animation()

// In case the window gets resized,
// then update the width and height
// of the canvas to the window's
window.onresize = function() {
  renderer.setSize(window.innerWidth, window.innerHeight)
  camera.aspect = window.innerWidth/window.innerHeight
  camera.updateProjectionMatrix()
}
