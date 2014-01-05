# MPU6050 = require "./MPU6050"
#
# mpu = new MPU6050
# setInterval ()->
#   mpu.read (err, result)->
#     console.log result
# , 200

Tracker = require "./PositionTracker"
tracker = new Tracker(50)

tracker.on "data", (frame)->
  accel    = "#{frame.accel[0]},#{frame.accel[1]},#{frame.accel[2]}"
  gyro     = "#{frame.gyro[0]},#{frame.gyro[1]},#{frame.gyro[2]}"
  position = "#{frame.position[0]},#{frame.position[1]},#{frame.position[2]}"

  accelMag = Math.sqrt(
    Math.pow(frame.accel[0], 2) +
    Math.pow(frame.accel[1], 2) +
    Math.pow(frame.accel[2], 2)
  )

  positionMag = Math.sqrt(
    Math.pow(frame.position[0], 2) +
    Math.pow(frame.position[1], 2) +
    Math.pow(frame.position[2], 2)
  )

  magnitude = "#{accelMag},#{positionMag},#{frame.timestamp}"

  process.stdout.write """
    #{accel}|#{gyro}|#{position}|#{magnitude}

  """

tracker.start()

