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
      return console.log(err) if err
      accel = result[0]
      gyro  = result[1]
      time  = result[2]
      initialFrame = new InitialFrame(accel, gyro, time)
      afterInit(initialFrame)

    @accelerometer.read afterRead.bind(@)

  run: (initialFrame)->
    step = 0
    stepSize = 10
    accel = initialFrame.accel
    gyro  = initialFrame.gyro

    applyXYZ = (fcn)->
      [0,1,2].map fcn, @

    average = (last, now)->
      last + (now / stepSize)

    getFrame = (prevFrame)->
      readResult = (err, result)->
        # return console.log(err) if err
        # step    += 1
        # avgAccel = (coord)-> ( average(accel[coord], result[0][coord]) )
        # avgGyro  = (coord)-> ( average(gyro[coord],  result[1][coord]) )
        # accel    = applyXYZ(avgAccel)
        # gyro     = applyXYZ(avgGyro)
        # time     = result[2]
        # if step % stepSize == 0
        #   newFrame = new Frame(initialFrame, prevFrame, accel, gyro, time)
        #   @emit "data", newFrame
        #   accel = applyXYZ (coord)->
        #     average(0, result[0][coord])
        #   gyro  = applyXYZ (coord)->
        #     average(0, result[1][coord])
        #   if @running
        #     setTimeout getFrame.bind(@, newFrame), @speed
        # else
        #   if @running
        #     setTimeout getFrame.bind(@, prevFrame), @speed

        return console.log(err) if err
        accel    = result[0]
        gyro     = result[1]
        time     = result[2]
        newFrame = new Frame(initialFrame, prevFrame, accel, gyro, time)
        @emit "data", newFrame

        if @running
          setTimeout getFrame.bind(@, newFrame), @speed

      @accelerometer.read readResult.bind(@)

    getFrame.call(@, initialFrame)

  start: ()->
    @running = true
    @init @run.bind(@)

  stop: ()->
    @running = false

  restart: ()->
    @stop()
    @start()

module.exports = PositionTracker
