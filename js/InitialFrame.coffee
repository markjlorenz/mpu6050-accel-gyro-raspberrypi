class InitialFrame
  constructor: (accelValues, gyroValues, timestamp)->
    @gAccel        = accelValues       # g
    @accel         = calcAccel.call(@) # m/s^2
    @gyro          = gyroValues        # deg/sec
    @timestamp     = timestamp         # ms
    @timeDelta     = [0,0,0]           # seconds
    @endVelocity   = [0,0,0]
    @positionDelta = [0,0,0]
    @position      = [0,0,0]

  tare: (accelValues, gyroValues, timestamp)->
    tareAccel = (coord)->
      accelValues[coord] - @gAccel[coord]

    tareGyro  = (coord)->
      gyroValues[coord] - @gyro[coord]

    [ applyXYZ.call(@, tareAccel),
      applyXYZ.call(@, tareGyro),
      timestamp ]

  calcAccel = ->
    times9_8 = (val)-> (val * 9.801)
    @gAccel.map times9_8, @

  applyXYZ = (fcn)->
    [0,1,2].map fcn, @

module.exports = InitialFrame
