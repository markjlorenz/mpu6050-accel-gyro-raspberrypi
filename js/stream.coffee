MPU6050 = require "./MPU6050"
# require "./Frame"

mpu = new MPU6050
setInterval ()->
  mpu.read (err, result)->
    console.log result
, 200
