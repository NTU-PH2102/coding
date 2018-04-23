// These are the code that controls
// the graphical user interface. Most
// of it is pretty self evident, plus
// I don't have much time left to
// comment this file deeply

document.getElementById("hello").onclick = function() {
  document.getElementById("hello").style.top = "100vh"
  setTimeout(function() {
    document.body.removeChild(document.getElementById("hello"))
  }, 750)
}

var doUpdateTimeout,
    doUpdateNow,
    doUpdate = [],
    updateInitTimeout,
    updateTailWidth = function() {
      // This function handles changes
      // to the tail width

      let groupLength = forceGroup.children.length

      if (groupLength != 2*opt.tailWidth) {

        if (groupLength > 2*opt.tailWidth)
          for (let i=groupLength; i>2*opt.tailWidth; i--)
            forceGroup.remove(tails[i])
        else
          for (let i=groupLength; i<=opt.tailWidth*2; i++)
            forceGroup.add(tails[i])

        for (let i=1; i<=2*opt.tailWidth; i++) {
          tails[i].material.opacity = tails[0].material.opacity * (1-(Math.ceil(i/2)-1)/opt.tailWidth)
          tails[i].material.needsUpdate = true
        }
      }
      controls.enabled = true
    }

function Options(V0, B0) {
  this.init(V0, B0)

  this.customSpeed = 1

  this.particleHistory = 10  // How long we would want the "tail"
                             // of the particle to run for, in s
                             // (real time)

  this.tailWidth = 5 // How many "tails" the force vectors should have

  this.showForceTrail =
  this.showForces     =
  this.showCage       =
  this.showGrid       =
  this.showGridLabels = true

  this.chaseCamera    = false
  this.toggleChase = function() {
    this.chaseCamera = !this.chaseCamera
    optChase.name((this.chaseCamera ? "Stop chasing":"Chase") + " it")
  }

  this.toggleM = function() {
    this.m = this.m < 1E-30 ? 1.6726219E-27:9.10938356E-31
    optM.name(
      "<span style='font-size: .7em'>Turn into a " +
      (this.q > 0 ? (this.m < 1E-30 ? "proton":"positron"):(this.m < 1E-30 ? "antiproton":"electron")) +
      "</span>"
    )

    if (doUpdate.indexOf("m") < 0)
      doUpdate.push("m")

    clearTimeout(doUpdateTimeout)
    doUpdateNow = true
  }

  this.toggleQ = function() {
    this.q *= -1
    optQ.name(
      "<span style='font-size: .8em'>Be " +
      (this.q < 0 ? "positive":"negative") +
      "</span>"
    )
    optM.name(
      "<span style='font-size: .7em'>Turn into a " +
      (this.q > 0 ? (this.m < 1E-30 ? "proton":"positron"):(this.m < 1E-30 ? "antiproton":"electron")) +
      "</span>"
    )

    if (doUpdate.indexOf("q") < 0)
      doUpdate.push("q")

    clearTimeout(doUpdateTimeout)
    doUpdateNow = true
  }

  this.updateV0 = function() {
    this.V0 = this.V * 10**this.Vscale

    if (doUpdate.indexOf("V0") < 0)
      doUpdate.push("V0")

    clearTimeout(doUpdateTimeout)
    doUpdateTimeout = setTimeout(function() {
      doUpdateNow = true
    }, 500)
  }

  this.updateB0 = function() {
    this.B0 = this.B * 10**this.Bscale

    if (doUpdate.indexOf("B0") < 0)
      doUpdate.push("B0")

    clearTimeout(doUpdateTimeout)
    doUpdateTimeout = setTimeout(function() {
      doUpdateNow = true
    }, 500)
  }

  this.Reset = function() {
    particle = new Particle
    this.init(particle.V0, particle.B0)

    this.customSpeed = 1
    this.particleHistory = 10
    this.tailWidth = 5

    doUpdateNow = true
  }
}
Options.prototype.init = function(V0, B0) {
  let V        = V0.toExponential().split("e")
  this.V0      = V0
  this.V       = Number(V[0])
  this.Vscale  = Number(V[1])

  let B       = B0.toExponential().split("e")
  this.B0     = B0
  this.B      = Number(B[0])
  this.Bscale = Number(B[1])

  this.position = particle.x(0)
  this.velocity = particle.v(0)

  this.m = particle.m
  this.q = particle.q

  if (typeof optInit != "undefined") {
    for (let i=0; i<3; i++) {
      optInit.__controllers[  i].setValue(opt.position[i])
      optInit.__controllers[3+i].setValue(opt.velocity[i])
    }
    for (let i in optTrap.__controllers)
      optTrap.__controllers[i].updateDisplay()
    for (let i in optAnim.__controllers)
      optAnim.__controllers[i].updateDisplay()

    optQ.name(
      "<span style='font-size: .8em'>Be " +
      (this.q < 0 ? "positive":"negative") +
      "</span>"
    )
    optM.name(
      "<span style='font-size: .7em'>Turn into a " +
      (this.q > 0 ? (this.m < 1E-30 ? "proton":"positron"):(this.m < 1E-30 ? "antiproton":"electron")) +
      "</span>"
    )

    updateTailWidth()
  }
}

var gui = new dat.GUI(),
    opt = new Options(particle.V0, particle.B0)

var optInit = gui.addFolder("Initial Conditions")
for (let k=0; k<2; k++) {
  for (let i=0; i<3; i++) {
    optInit
      .add((k == 1 ? opt.velocity:opt.position), i.toString(), -10, 10, 1E-3)
      .name((k == 1 ? "v<sub>":"") + ["x", "y", "z"][i] + (k == 1 ? "</sub>":""))
      .onChange(function(value) {
        (k==1 ? opt.velocity:opt.position)[i] = value
        controls.enabled = false
      })
      .onFinishChange(function() {
        clearTimeout(updateInitTimeout)
        updateInitTimeout = setTimeout(function() {
          particle.init(opt.position, opt.velocity)
          doUpdateNow = true
        }, 500)
        controls.enabled = true
      })
  }
}

var optTrap = gui.addFolder("Trap Parameters")
optTrap
  .add(opt, "V", 1, 9, .01)
  .name("V<sub>0</sub>")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    opt.updateV0()
    controls.enabled = true
  })
optTrap
  .add(opt, "Vscale", -6, 6, 1)
  .name("<span style='margin: 0 1em;'></span> × 10^")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    opt.updateV0()
    controls.enabled = true
  })
optTrap
  .add(opt, "B", 1, 9, .01)
  .name("B<sub>0</sub>")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    opt.updateB0()
    controls.enabled = true
  })
optTrap
  .add(opt, "Bscale", -6, 6, 1)
  .name("<span style='margin: 0 1em;'></span> × 10^")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    opt.updateB0()
    controls.enabled = true
  })
optTrap.open()

var optAnim = gui.addFolder("Animation Options")
optAnim
  .add(opt, "particleHistory", 1E-2, 20, 1E-2)
  .name("Tail length (s)")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    controls.enabled = true
  })
optAnim
  .add(opt, "showForceTrail")
  .name("Force Trails")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    scene.remove(forceGroup)
    if (opt.showForceTrail)
      scene.add(forceGroup)
    controls.enabled = true
  })
var optTailWidth = optAnim
  .add(opt, "tailWidth", 1, 10, 1)
  .name("Tail width")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(updateTailWidth)
optAnim
  .add(opt, "customSpeed", 1E-2, 5, 1E-2)
  .name("Speed")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    document.getElementById("infoSpeed").innerHTML = (particle.scale.t*( opt.customSpeed || 1 )).toPrecision(3).replace("e", "&times;10<sup>") + "</sup>"
    controls.enabled = true
  })
optAnim
  .add(opt, "showForces")
  .name("Force Vectors")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    scene.remove(forceArrows.B)
    scene.remove(forceArrows.E)
    if (opt.showForces){
      scene.add(forceArrows.B)
      scene.add(forceArrows.E)
    }
    controls.enabled = true
  })
optAnim
  .add(opt, "showCage")
  .name("Trap Boundaries")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    scene.remove(cage)
    if (opt.showCage && particle.stable.z && particle.stable.xy)
      scene.add(cage)
    controls.enabled = true
  })
optAnim.open()

var optGrid = gui.addFolder("Grid Options")
optGrid
  .add(opt, "showGrid")
  .name("Grid Lines")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    scene.remove(gridObjectGroup)
    if (opt.showGrid)
      scene.add(gridObjectGroup)
    controls.enabled = true
  })
optGrid
  .add(opt, "showGridLabels")
  .name("Axis Labels")
  .onChange(function() {
    controls.enabled = false
  })
  .onFinishChange(function() {
    scene.remove(gridLabelGroup)
    if (opt.showGridLabels)
      scene.add(gridLabelGroup)
    controls.enabled = true
  })
optGrid.open()


var optChase = gui
                .add(opt, "toggleChase")
                .name("Chase it"),
    optM     = gui
                .add(opt, "toggleM")
                .name("<span style='font-size: .7em'>Turn into a proton</span>")
    optQ     = gui
                .add(opt, "toggleQ")
                .name("<span style='font-size: .8em'>Be negative</span>")

gui.add(opt, "Reset")
