Sylvester = require("./vendor/sylvester-0.2.0.js")
$V = Sylvester.Vector
$M = Sylvester.Matrix

class InitialRotator
  constructor: (accel)->
    @accel     = accel               # m/sec^2
    @gyro      = [0, 0, 0]           # deg/sec
    @angle     = [0, 0, 0]           # deg
    @timeDelta = 0                   # seconds
    @matrix    = calcMatrix.call(@)

  rotate: (accel)->
    accelVector = $V.create(accel)
    rotated     = @matrix.x(accelVector)
    [ rotated.e(1), rotated.e(2), rotated.e(3) ]

  calcMatrix = ->
    g     = $V.create(@accel)
    zRaw  = g.multiply(-1)
    zAxis = zRaw.toUnitVector()
    rawY  = $V.create([0, zAxis.e(3), -1 * zAxis.e(2)])
    yAxis = rawY.toUnitVector()
    xAxis = yAxis.cross(zAxis)

    $M.create([
      [xAxis.e(1), xAxis.e(2), xAxis.e(3)],
      [yAxis.e(1), yAxis.e(2), yAxis.e(3)],
      [zAxis.e(1), zAxis.e(2), zAxis.e(3)]
    ])

  d2r = (deg)->
    deg * Math.PI / 180

module.exports = InitialRotator
