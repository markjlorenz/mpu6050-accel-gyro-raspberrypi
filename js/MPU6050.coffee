class MPU6050

  i2c     = require "i2c"
  address = 0x68
  device  = "/dev/i2c-1"
  wire    = new i2c(address, {device: device})

  # Put the MPU6050 into "active" mode
  # *Doesn't work, use the included c-lang example in `bin/`*
  activateAddress = 0x6B
  activateValue   = 0x00
  wire.writeBytes activateAddress, [activateValue], (err)->
    console.log err if err

  command = 0x3B  # starting register for accel/gyro values
  length  = 14    # read all accel/gyro (there's a temp in the middle too)

  constructor: ()->

  read: (callback)->
    currentBytes = (err, res)->
      accel = @calAccel(res.slice(0, 6))
      gyro  = @calAccel(res.slice(8, 14))

      callback err, [accel, gyro, Date.now()]
    wire.readBytes command, length, currentBytes.bind(@)

  applyBuffToEng: (calFactor)->
    (buffer) -> ( buffer.readInt16BE(0) * calFactor )

  sliceVector: (vector)->
    [ vector.slice(0, 2),
      vector.slice(2, 4),
      vector.slice(4 ,6) ]

  calAccel: (accelSlice)->
    fullscale_eng   = 2      # unit: g
    fullscale_bits  = 32767  # 16 bits / 2
    calFactor       = fullscale_eng / fullscale_bits

    @sliceVector(accelSlice).map @applyBuffToEng(calFactor)

  calGyro: (gyroSlice)->
    fullscale_eng   = 250    # unit: deg/sec
    fullscale_bits  = 32767  # 16 bits / 2
    calFactor       = fullscale_eng / fullscale_bits

    @sliceVector(gyroSlice).map @applyBuffToEng(calFactor)

module.exports = MPU6050
