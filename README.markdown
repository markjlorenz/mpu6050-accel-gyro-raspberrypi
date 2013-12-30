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
