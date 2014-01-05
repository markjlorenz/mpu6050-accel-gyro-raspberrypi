Sylvester = require("./vendor/sylvester-0.2.0.js")
$V = Sylvester.Vector
$M = Sylvester.Matrix

class Rotator
  constructor: (@lastRotation, gyroValues, timeDelta)->
    @gyro      = gyroValues           # deg/sec
    @timeDelta = timeDelta            # seconds
    @matrix    = calcMatrix.call(@)

  rotate: (accel)->
    accelVector = $V.create(accel)
    rotated     = @matrix.x(accelVector)
    [ rotated.e(1), rotated.e(2), rotated.e(3) ]

  d2r = (deg)->
    deg * Math.PI / 180

  calcMatrix = ->
    xRotation = $M.RotationX( d2r(@gyro[0])*@timeDelta )
    yRotation = $M.RotationY( d2r(@gyro[1])*@timeDelta )
    zRotation = $M.RotationZ( d2r(@gyro[2])*@timeDelta )
    matrix    = @lastRotation.matrix.x( xRotation )
    matrix    = matrix.x( yRotation )
    matrix    = matrix.x( zRotation )

module.exports = Rotator
