#For python3 only
#pip3 install pyserial
#sudo python3 uart.py

import serial           # import the module
import struct
import time
import random
#import bitstring
#from bitstring import BitArray

def inttobyte(inp):
    flag = 0
    inp16 = ""
    bin_inp = bin(inp)
    Inp = inp
    if inp < 0 and inp > -32769:
        inp = -inp
        bin_inp = bin(inp)
        bin_inp = bin_inp[2:]
        bin_inp = bin_inp.replace('0', '2')
        bin_inp = bin_inp.replace('1', '0')
        bin_inp = bin_inp.replace('2', '1')
        comp_inp = "0b1" + bin_inp
        inp = int(comp_inp, 2)
        inp = inp + 1
        bin_inp = bin(inp)
    elif inp >= 0 and inp < 32768:
        flag = 1
        bin_inp = bin(inp)
    if len(bin_inp) < 18:
    	if flag != 1:
            inp16 = inp16 + '1'*(18 - len(bin_inp))
    	else:
            inp16 = inp16 + '0'*(18 - len(bin_inp))
    if Inp == -32768:
        inp16 = inp16 + bin_inp[2:]
        bytes = (32768).to_bytes(2,byteorder = "big")
    else :
        inp16 = inp16 + bin_inp[2:]
        bytes = int('0b'+inp16,2).to_bytes(2,byteorder = "big")
    #msb = int('0b'+inp16[8:15],2).to_bytes(1,byteorder = "big")
    lsb = bytes[1].to_bytes(1,byteorder = "big")
    msb = bytes[0].to_bytes(1,byteorder = "big")
    return [lsb,msb]
def bytestoint(inp):
    binary = bin(inp[0])[2:].zfill(8) + bin(inp[1])[2:].zfill(8) + bin(inp[2])[2:].zfill(8) + bin(inp[3])[2:].zfill(8)
    if binary[0] == '1':
        binary = binary.replace('0', '2')
        binary = binary.replace('1', '0')
        binary = binary.replace('2', '1')
        binary = "0b" + binary
        inp = int(binary,2)
        inp = -inp - 1
    else :
        binary = "0b" + binary
        inp = int(binary,2)
    return inp
ComPort = serial.Serial('/dev/ttyUSB1') # open COM24
ComPort.baudrate = 115200 # set Baud rate to 9600
ComPort.bytesize = 8    # Number of data bits = 8
ComPort.parity   = 'N'  # No parity
ComPort.stopbits = 1    # Number of Stop bits = 1
# Write character 'A' to serial port
#data=bytearray(b'A')
RED = 0;
n = 100000
for i in range(n):
    x = random.randint(-32768,32767)
    y = random.randint(-32768,32767)
    print(i)
    [lsb,msb] = inttobyte(x)
    ot= ComPort.write(lsb)    #for sending data to FPGA
    ot= ComPort.write(msb)    #for sending data to FPGA
    #print ("enter a number for data1 in range(-32768 to 32767):"),
    
    [lsb,msb] = inttobyte(y)
    ot= ComPort.write(lsb)    #for sending data to FPGA
    ot= ComPort.write(msb)    #for sending data to FPGA

    it=(ComPort.read(4))                #for receiving data from FPGA
    #print ("data received from FPGA (data1*data2):"),
    p=bytestoint(it)
    #p=BitArray(it)
    #print (it)
    #print(p)
    #print (x*y)
    exact = x*y
    if(p != exact):
        print(abs((p-exact)/exact))
        RED +=  abs((p-exact)/exact) 
        print(RED)
print("success")
MRED = (RED/n)*100
print(MRED)
#For docs about this https://docs.python.org/3/library/stdtypes.html search for "int.from_bytes" function
    
#it=(ComPort.read(1))                #for receiving data from FPGA
#print(it)
#print ("data received from FPGA (data1+data2):"),
#print (int.from_bytes(it, byteorder='big'))
#For docs about this https://docs.python.org/3/library/stdtypes.html search for "int.from_bytes" function
ComPort.close()         # Close the Com port
