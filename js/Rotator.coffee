Sylvester = require("./vendor/sylvester-0.2.0.js")
$V = Sylvester.Vector
$M = Sylvester.Matrix

class Rotator
  constructor: (@lastRotation, gyroValues, accelValues, timeDelta)->
    @gyro      = gyroValues            # deg/sec
    @accel     = accelValues           # g
    @timeDelta = timeDelta             # seconds
    @raw       = calcAngle.call(@)     # degrees
    # @angle     = complimentary.call(@) # degrees
    @angle     = @raw                    # degrees
    @matrix    = calcMatrix.call(@)

  rotate: (accel)->
    accelVector = $V.create(accel)
    rotated     = @matrix.x(accelVector)
    [ rotated.e(1), rotated.e(2), rotated.e(3) ]

  d2r = (deg)->
    deg * Math.PI / 180

  calcAngle = ->
    applyXYZ.call @, (coord)-> (@gyro[coord]*@timeDelta)

  complimentary = ->
    filter = (coord)->
      square = (val)-> (Math.pow(val, 2))
      accelMag = Math.sqrt( square(@accel[(coord+1) % 3]) + square(@accel[(coord+2) % 3]) )
      # 0.98*(@lastRotation.angle[coord]+@raw[coord]) + 0.02*(accelMag)
      0.98*(@raw[coord]) + 0.02*(accelMag)
    applyXYZ.call @, filter

  calcMatrix = ->
    xRotation = $M.RotationX( d2r(@angle[0]) )
    yRotation = $M.RotationY( d2r(@angle[1]) )
    zRotation = $M.RotationZ( d2r(@angle[2]) )
    matrix    = @lastRotation.matrix.x( xRotation )
    matrix    = matrix.x( yRotation )
    matrix    = matrix.x( zRotation )

  applyXYZ = (fcn)->
    [0,1,2].map fcn, @

module.exports = Rotator
