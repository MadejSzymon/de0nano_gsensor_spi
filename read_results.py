import keyboard
import serial as sr
import pylab as P

COM_PORT = 'COM5'
BAUD_RATE = 19200
G_RANGE = 4
G_VALUE = 9.80665

P.close('all')
P.figure()
P.ion()
P.show()
ax = P.axes(projection='3d')
start = [0, 0, 0]
s = sr.Serial(port=COM_PORT, baudrate=BAUD_RATE, bytesize=8, timeout=2, stopbits=sr.STOPBITS_ONE)

x = -1
temp = ["", "", "", "", "", ""]


def bits_to_g(temp_a, temp_b):
    temp_merged = temp_a + temp_b
    if temp_merged[0] == '0':
        temp_merged = int(temp_merged, 2)
    else:
        inverse_s = ''
        for h in temp_merged:

            if h == '0':
                inverse_s += '1'

            else:
                inverse_s += '0'
        temp_merged = inverse_s
        temp_merged = ~int(temp_merged, 2) + 1
    sample_converted = temp_merged / 1024 * G_RANGE * G_VALUE
    return sample_converted


while True:
    if x == 5:
        s.open()
    a = s.read()
    a = int.from_bytes(a, byteorder='big')
    if a == 255:
        x = -1
    else:
        x = x + 1

    if x == 0:
        temp[0] = '{:08b}'.format(a)[6:8]
    if x == 1:
        temp[1] = '{:08b}'.format(a)
    if x == 2:
        temp[2] = '{:08b}'.format(a)[6:8]
    if x == 3:
        temp[3] = '{:08b}'.format(a)
    if x == 4:
        temp[4] = '{:08b}'.format(a)[6:8]
    elif x == 5:
        temp[5] = '{:08b}'.format(a)
        sample_converted_z = bits_to_g(temp[0], temp[1])
        sample_converted_y = bits_to_g(temp[2], temp[3])
        sample_converted_x = bits_to_g(temp[4], temp[5])
        s.flush()
        s.close()
        vec_x = [sample_converted_x, 0, 0]
        vec_y = [0, sample_converted_y, 0]
        vec_z = [0, 0, sample_converted_z]
        P.cla()
        ax.set_title('Readings from accelerometer \n Press "Esc" to close')
        ax.set_xlim([-20, 20])
        ax.set_ylim([-20, 20])
        ax.set_zlim([-20, 20])
        arrow_x = ax.quiver(start[0], start[1], start[2], vec_x[0], vec_x[1], vec_x[2], color='red', label=f'X : {round(sample_converted_x,2 )} $m/s^2$')
        arrow_y = ax.quiver(start[0], start[1], start[2], vec_y[0], vec_y[1], vec_y[2], color='green', label=f'Y : {round(sample_converted_y,2)} $m/s^2$')
        arrow_z = ax.quiver(start[0], start[1], start[2], vec_z[0], vec_z[1], vec_z[2], color='blue', label=f'Z : {round(sample_converted_z,2)} $m/s^2$')
        ax.legend()
        P.pause(0.00001)
    if keyboard.is_pressed('Esc'):
        break
