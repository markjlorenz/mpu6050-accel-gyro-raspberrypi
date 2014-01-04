# The MPU-6050 Accel/Gyro

- [http://www.invensense.com/mems/gyro/documents/PS-MPU-6000A-00v3.4.pdf](http://www.invensense.com/mems/gyro/documents/PS-MPU-6000A-00v3.4.pdf)
- [http://invensense.com/mems/gyro/documents/RM-MPU-6500A-00.pdf](http://invensense.com/mems/gyro/documents/RM-MPU-6500A-00.pdf)

```bash
mark@raspberrypi ~/gyros $: → i2cdetect -y 1
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- 68 -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --

# looks like we're on register 0x68
```

```bash
# Read the WHOAMI (note: `-s` and `-r` are in decmial)
sudo bin/i2c-clang-example -dp -s104 -r117 1

# Running ...
# Clock divider set to: 148
# len set to: 1
# Slave address set to: 104
# Read Partial: 75
# Read Result = 0
#
# Read Buf[0] = 68
# ... done!
# Note: the datasheet lies, the WHOAMI value is 0x68 not 0x70
```

```bash
# Put it into active mode:
sudo ./bin/i2c-clang-example -dw -s104 2 0x6B 0x00
```

```bash
# Read the X gyro:
sudo bin/i2c-clang-example -dp -s104 -r67 2

# Running ...
# Clock divider set to: 148
# len set to: 2
# Slave address set to: 104
# Read Partial: 43
# Read Result = 0
#
# Read Buf[0] = ff  << MSB
# Read Buf[1] = ac  << LSB
# ... done!
```


## Calculating the Rotation Matrix
### Overview:
```octave
# a sample acceleration reading at rest
octave:33> g = [1.010040589617603, 0.0065919980468153935, 0.09399700918607135]
g =

   1.0100406   0.0065920   0.0939970

octave:34> rawZ = -g
rawZ =

  -1.0100406  -0.0065920  -0.0939970

octave:35> zAxis = rawZ/norm(rawZ)
zAxis =

  -0.9956766  -0.0064983  -0.0926603

octave:36> rawY = [0, zAxis(3), -zAxis(2)]
rawY =

   0.000000  -0.092660   0.006498

octave:37> yAxis = rawY / norm(rawY)
yAxis =

   0.00000  -0.99755   0.06996

octave:38> xAxis = cross(yAxis, zAxis)
xAxis =

   0.092888  -0.069656  -0.993237

octave:39> R = [xAxis'; yAxis'; zAxis']
R =

   0.09289   0.00000  -0.99568
  -0.06966  -0.99755  -0.00650
  -0.99324   0.06996  -0.09266
```

```octave
# now when `g` is multiplied with the rotation matrix we get the earth-centric reading
octave:40> R*g'
ans =

   2.2987e-04
  -7.7542e-02
  -1.0115e+00

# note `g'` is the transpose of `g` we need a column vector here not a row vector
```

Rotating the rotation matrix (when the device rotates after inital calibration):
```octave
octave> g1 = [ 1, 0, 0 ]
octave> r  = rotMatrix(g1)   # calculate the initial rotation matrix, converting device => N,E,D coordinates

octave> function r = d2r(deg)
  r = deg * pi / 180;
endfunction

octave> function R = degRotZMatrix(deg)
  R = [ cos(d2r(deg)), -sin(d2r(deg)), 0
        sin(d2r(deg)),  cos(d2r(deg)), 0
        0            ,  0            , 1 ];
endfunction

#In the next data-frame the device has rotated.  The device => N,E,D mapping needs updated
octave> g2 = [ 0.707, 0.707, 0 ]  # accelerometer readings after a 45deg clockwise rotation about Z as determined by gyros.
                                  # This should map to [ 0, 0, -1 ]

octave> newRotationMatrix = r * degRotZMatrix(-45)  # Clockwise is negative
octave> newRotationMatrix * g2'                     # This should eq N,E,D [ 0, 0 , -1 ]

ans =

   9.1881e-02
   6.9958e-05
  -9.9562e-01
```
