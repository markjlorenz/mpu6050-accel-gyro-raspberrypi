InitialRotation = require("./InitialRotation")
Gravity  = require("./Gravity")
Matrix = require("./Matrix")

class InitialFrame
  constructor: ()->
  # constructor: (accelValues, gyroValues, timestamp)->
    @calCount = 0
    # @gAccel        = accelValues          # g
    # @accelAndGrav  = calcAccel.call(@)    # m/s^2
    # @gyro          = gyroValues           # deg/sec
    # @rotation      = calcRotation.call(@)
    # @accel         = normalAccel.call(@)
    # @timestamp     = timestamp            # ms
    @timeDelta     = 0                    # seconds
    @endVelocity   = [0,0,0]
    @positionDelta = [0,0,0]
    @position      = [0,0,0]
    # @scaleMatrix  = scale.call(@)
    @gAccel        = null
    @accelAndGrav  = null
    @gyro          = null
    @rotation      = null
    @accel         = null
    @gyros = []
    @accels = []

  addCalData: (accel, gyro, timestamp)=>
    @timestamp = timestamp
    @calCount += 1
    @accels = @accels.concat [accel]
    @gyros = @gyros.concat [gyro]

  finalizeCal: ()=>
    sumFn = (coord)->
      (pv, cv)-> ( pv + cv[coord] )

    accelValues = applyXYZ (coord)=>
      sum = @accels.reduce sumFn(coord), 0
      sum / @calCount
    gyroValues = applyXYZ (coord)=>
      sum = @gyros.reduce sumFn(coord), 0
      sum / @calCount

    @gAccel        = accelValues          # g
    @accelAndGrav  = calcAccel.call(@)    # m/s^2
    @gyro          = gyroValues           # deg/sec
    @rotation      = calcRotation.call(@)
    @accel         = normalAccel.call(@)
    @scaleMatrix   = scale.call(@)

  tare: (accel)->
    t = (coord)-> ( @accel[coord] - accel[coord] )
    applyXYZ.call @, t

  normalAccel = ->
    inNED = @rotation.rotate(@accelAndGrav)
    [ inNED[0], inNED[1], inNED[2] + Gravity ]

  calcAccel = ->
    times9_8 = (coord)-> (@gAccel[coord] * Gravity)
    applyXYZ.call @, times9_8

  calcRotation = ->
    new InitialRotation(@accelAndGrav)

  scale = ->
    new Matrix.ScaleMatrix(@gAccel)

  scale: (array)=>
    @scaleMatrix.scaled(array)

  applyXYZ = (fcn)->
    [0,1,2].map fcn, @

module.exports = InitialFrame
