{EventEmitter}  = require "events"
Frame           = require "./Frame"
InitialFrame    = require "./InitialFrame"
MPU6050         = require "./MPU6050"

class PositionTracker extends EventEmitter
  constructor: (@speed)->
    @speed       or= 50
    @accelerometer = new MPU6050
    @running       = false

  init: (afterInit)->
    afterRead = (err, result)->
      accel = result[0]
      gyro  = result[1]
      time  = result[2]
      initialFrame = new InitialFrame(accel, gyro, time)
      afterInit(initialFrame)

    mpu.read afterRead.bind(@)

  run: (initialFrame)->
    readResult = (err, values)->
      return console.log(err) if err
      accel    = result[0]
      gyro     = result[1]
      time     = result[2]
      newFrame = new Frame(lastFrame, accel, gyro, time)
      @emit "data", newFrame

      if @running
        setTimeout run(newFrame).bind(@), @speed

    @accelerometer.read readResult.bind(@)

  start: ()->
    @running = true
    @init(@run)

  stop: ()->
    @running = false

  restart: ()->
    @stop()
    @start()

module.exports = PositionTracker
