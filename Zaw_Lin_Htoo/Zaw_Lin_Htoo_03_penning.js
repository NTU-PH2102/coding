// Almost everything here is just
// writing out the math calculations
// from the writeup in code, so not
// much programming here

function Particle(x=[.25, .25, .2], v=[1,1,1], m=9.10938356E-31, q=1.60217662E-19, V0=5E4, B0=1.9, d=1E-3) {
  this.init(x, v, m, q, V0, B0, d)
}
Particle.prototype.init = function(x, v, m, q, V0, B0, d) {
  /*
    Define an object type Particle,
    which we will use as a prototype
    for each particle. The reason we
    define an object so we can handle
    things much easier when the user
    changes the environment variables

    x is the POSITION VECTOR where
      x[0] is x
      x[1] is y
      x[2] is z
    v is the VELOCITY VECTOR
      (see above)
    m is the MASS
    q is the CHARGE
    V0 is... V0
    B0 is... you get the drift
    d is the characteristic trap dimension
  */

  this.m     = m  || this.m
  this.q     = q  || this.q
  this.V0    = V0 || this.V0
  this.B0    = B0 || this.B0
  this.d     = d  || this.d

  this.stable = {
    z:  ( this.q*this.V0 )/( this.m*this.d**2 ) > 0,
    xy: 2*this.m*this.V0/this.q/((this.B0*this.d)**2) < 1
  }

  var omega = this.q*this.B0/2/this.m,
      Omega = omega*Math.sqrt( Math.abs(1 - 2*this.m*this.V0/this.q/((this.B0*this.d)**2)) )

  this.omega = omega
  this.Omega = Omega

  this.a     = [
                 [x[0], (v[0]-omega*x[1])/Omega],
                 [x[1], (v[1]+omega*x[0])/Omega]
               ]
  this.A     = [
                 .5*Math.sqrt( x[0]**2 + ( (v[0] - omega*x[1])/Omega )**2 ),
                 .5*Math.sqrt( x[1]**2 + ( (v[1] + omega*x[0])/Omega )**2 ),
                 x[2]
               ]
  this.Osum  = Omega + omega
  this.Odiff = Omega - omega
  this.Oz    = Math.sqrt( Math.abs(( this.q*this.V0 )/( this.m*this.d**2 )) )
  this.Bz    = v[2]/this.Oz
  this.Px    = Math.atan2( v[0] - omega*x[1], Omega*x[0] )
  this.Py    = Math.atan2( v[1] + omega*x[0], Omega*x[1] )
  this.scale = {
                 t: Math.PI / Math.max(
                      this.Osum, this.Oz, this.Osum
                    )/2,
                 x: 10/Number(
                      Math.sqrt( this.A[0]**2 + this.A[1]**2 ).toPrecision(1)
                    )
               }
  this.caps  = [
                 2*Math.sqrt( this.A[0]**2 + this.A[1]**2 ),
                 2*Math.sqrt( this.A[0]**2 + this.A[1]**2 ),
                   Math.sqrt( this.A[2]**2 + this.Bz**2 )
               ]
}
Particle.prototype.x = function(t) {
  let x

  if (this.stable.xy) {
    x = [
      this.A[0] *
            (
               Math.cos( this.Osum*t  - this.Px ) +
               Math.cos( this.Odiff*t - this.Px )
            ) +
          this.A[1] *
            (
               Math.sin( this.Osum*t  - this.Py ) -
               Math.sin( this.Odiff*t - this.Py )
            ),
      this.A[0] *
            (
              -Math.sin( this.Osum*t  - this.Px ) +
               Math.sin( this.Odiff*t - this.Px )
            ) +
          this.A[1] *
            (
              Math.cos( this.Osum*t  - this.Py ) +
              Math.cos( this.Odiff*t - this.Py )
            )
    ]
  } else {
    let Ax = this.a[0][0]*Math.cosh(this.Omega * t) +
             this.a[0][1]*Math.sinh(this.Omega * t),
        Ay = this.a[1][0]*Math.cosh(this.Omega * t) +
             this.a[1][1]*Math.sinh(this.Omega * t)
    x = [
           Ax*Math.cos(this.omega * t) + Ay*Math.sin(this.omega * t),
          -Ax*Math.sin(this.omega * t) + Ay*Math.cos(this.omega * t)
        ]
  }

  if (this.stable.z)
    x.push(
      this.A[2] * Math.cos( this.Oz*t ) +
      this.Bz   * Math.sin( this.Oz*t )
    )
  else
    x.push(
      this.A[2] * Math.cosh( this.Oz*t ) +
      this.Bz   * Math.sinh( this.Oz*t )
    )

  return x
}
Particle.prototype.v = function(t) {
  let v

  if (this.stable.xy) {
    v = [
      -this.A[0] *
            (
              this.Osum  * Math.sin( this.Osum*t  - this.Px ) +
              this.Odiff * Math.sin( this.Odiff*t - this.Px )
            ) +
           this.A[1] *
            (
              this.Osum  * Math.cos( this.Osum*t  - this.Py ) -
              this.Odiff * Math.sin( this.Odiff*t - this.Py )
            ),
       this.A[0] *
            (
              -this.Osum  * Math.cos( this.Osum*t  - this.Px ) +
               this.Odiff * Math.cos( this.Odiff*t - this.Px )
            ) +
          -this.A[1] *
            (
              this.Osum  * Math.sin( this.Osum*t  - this.Py ) +
              this.Odiff * Math.sin( this.Odiff*t - this.Py )
            )
    ]
  } else {
    let AxC = this.a[0][0]*Math.cosh(this.Omega * t) +
              this.a[0][1]*Math.sinh(this.Omega * t),
        AxS = this.a[0][0]*Math.sinh(this.Omega * t) +
              this.a[0][1]*Math.cosh(this.Omega * t),
        AyC = this.a[1][0]*Math.cosh(this.Omega * t) +
              this.a[1][1]*Math.sinh(this.Omega * t),
        AyS = this.a[1][0]*Math.sinh(this.Omega * t) +
              this.a[1][1]*Math.cosh(this.Omega * t)
    v = [
           AxS*Math.cos(this.omega * t)*this.Omega -
             AxC*Math.sin(this.omega * t)*this.omega +
             AyS*Math.sin(this.omega * t)*this.Omega +
             AyC*Math.cos(this.omega * t)*this.omega,
           -AxS*Math.sin(this.omega * t)*this.Omega -
             AxC*Math.cos(this.omega * t)*this.omega +
             AyS*Math.cos(this.omega * t)*this.Omega -
             AyC*Math.sin(this.omega * t)*this.omega
        ]
  }

  if (this.stable.z)
    v.push(
      -this.A[2] * this.Oz * Math.sin( this.Oz*t ) +
       this.Bz   * this.Oz * Math.cos( this.Oz*t )
    )
  else
    v.push(
       this.A[2] * this.Oz * Math.sinh( this.Oz*t ) +
       this.Bz   * this.Oz * Math.cosh( this.Oz*t )
    )

  return v
}
Particle.prototype.F = function(t) {
  var x = this.x(t),
      v = this.v(t)
  return {
    B: [
       this.q * this.B0 * v[1],
      -this.q * this.B0 * v[0],
       0
    ],
    E: [
       this.q * this.V0 / this.d**2 * x[0]/2,
       this.q * this.V0 / this.d**2 * x[1]/2,
      -this.q * this.V0 / this.d**2 * x[2]
    ]
  }
}

// The following functions are pretty self explanatory,
// the main thing being that they take the current position
// and velocity, and use it as the new "initial" conditions
Particle.prototype.setV0 = function(V0, t=0) {
  this.init(this.x(t), this.v(t), this.m, this.q, V0 || this.V0, this.B0, this.d)
}
Particle.prototype.setB0 = function(B0, t=0) {
  this.init(this.x(t), this.v(t), this.m, this.q, this.V0, B0 || this.B0, this.d)
}
Particle.prototype.setD = function(d, t=0) {
  this.init(this.x(t), this.v(t), this.m, this.q, this.V0, this.B0, d || this.d)
}
Particle.prototype.setM = function(m, t=0) {
  this.init(this.x(t), this.v(t), m || this.m, this.q, this.V0, this.B0, this.d)
}
Particle.prototype.setQ = function(q, t=0) {
  this.init(this.x(t), this.v(t), this.m, q || this.q, this.V0, this.B0, this.d)
}
