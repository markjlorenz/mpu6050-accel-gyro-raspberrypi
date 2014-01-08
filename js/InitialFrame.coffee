InitialRotation = require("./InitialRotation")
Gravity  = require("./Gravity")

class InitialFrame
  constructor: (accelValues, gyroValues, timestamp)->
    @gAccel        = accelValues          # g
    @accelAndGrav  = calcAccel.call(@)    # m/s^2
    @gyro          = gyroValues           # deg/sec
    @rotation      = calcRotation.call(@)
    @accel         = normalAccel.call(@)
    @timestamp     = timestamp            # ms
    @timeDelta     = 0                    # seconds
    @endVelocity   = [0,0,0]
    @positionDelta = [0,0,0]
    @position      = [0,0,0]

  tare: (accel)->
    t = (coord)-> ( @accel[coord] - accel[coord] )
    applyXYZ.call @, t

  normalAccel = ->
    inNED = @rotation.rotate(@accelAndGrav)
    [ inNED[0], inNED[1], inNED[2] ]

  calcAccel = ->
    times9_8 = (coord)-> (@gAccel[coord] * Gravity)
    applyXYZ.call @, times9_8

  calcRotation = ->
    new InitialRotation(@accelAndGrav)

  applyXYZ = (fcn)->
    [0,1,2].map fcn, @

module.exports = InitialFrame
