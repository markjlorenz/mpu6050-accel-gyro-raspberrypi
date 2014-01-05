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
  # console.log "---", frame
  console.log frame.accel
  console.log frame.gyro
  console.log frame.position
  console.log '----------'
tracker.start()

