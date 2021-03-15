#!/usr/bin/env python3

# Comments from this tutorial - https://realpython.com/python-sockets/

# FT terminal:
# cd C:\dev\fictrac-master\sample
# ..\bin\Release\fictrac.exe config_live_feed_with_socket.txt

# The FT terminal will appear to hang. That’s because the server is blocked (suspended) in a call.
# It’s waiting for a client connection. Now open another terminal window or command prompt
# and run the client:
# cd C:\dev\fictrac-master\scripts
# py socket_client_360.py

import time
import socket
from Phidget22.Phidget import *
from Phidget22.Devices.VoltageOutput import *
import numpy as np



# *********** SET SOCKET INFO ***********

HOST = '127.0.0.1'  # Standard loopback interface address (localhost)
PORT = 65413  # Port to listen on (non-privileged ports are > 1023)
# Phidget serial number = 525487   (Berg 2, MM & YEF controller)


# *********** SET AOUT PARAMETERS ********
rate_to_volt_const = 50,
aout_max_volt = 10.0,
aout_min_volt = 0.0,
aout_max_volt_vel = 10.0,
aout_min_volt_vel = 0.0,
lowpass_cutoff = 0.5,



# *********** INITIALIZE AOUT CHANNELS ***********

# Beginning values (to keep track of accumulated heading)
accum_heading = 0
accum_x = 0
accum_y = 0

# Setup analog output 'yaw gain' for integrated heading position
    # Sent to DAQ and ADC2 for closed loop (split)
aout_yawGain = VoltageOutput()
aout_yawGain.setChannel(0)
aout_yawGain.openWaitForAttachment(5000)
aout_yawGain.setVoltage(0.0)

# Setup analog output 'int x' for integrated x position
    # Sent to DAQ
aout_int_forward = VoltageOutput()
aout_int_forward.setChannel(1)
aout_int_forward.openWaitForAttachment(5000)
aout_int_forward.setVoltage(0.0)

# Setup analog output 'int y' for integrated y position
    # Sent to DAQ
aout_int_side = VoltageOutput()
aout_int_side.setChannel(2)
aout_int_side.openWaitForAttachment(5000)
aout_int_side.setVoltage(0.0)

# Setup analog output - currently unused
aout_blank = VoltageOutput()
aout_blank.setChannel(3)
aout_blank.openWaitForAttachment(5000)
aout_blank.setVoltage(0.0)



# *********** OPEN CONNECTION AND BEGIN FICTRAC ***********

# Open the connection (FicTrac must be waiting for socket connection) and get data until FT closes....

# Below we create a socket object using socket.socket() and specify the socket type as socket.SOCK_STREAM.
# When you do that, the default protocol that’s used is the Transmission Control Protocol (TCP). This is a good
# default and probably what you want. # The object can be used w/in a with statement and there's no need to call s.close().

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:

    sock.connect((HOST, PORT))
    data = ""

    # Keep receiving data until FicTrac closes

    while True:

        # Receive one data frame
        new_data = sock.recv(1024)
        if not new_data:
            break

        # Decode received data
        data += new_data.decode('UTF-8')

        # Find the first frame of data
        endline = data.find("\n")
        line = data[:endline]  # copy first frame
        data = data[endline + 1:]  # delete first frame

        # Tokenise
        toks = line.split(", ")

        # Fixme: sometimes we read more than one line at a time,
        # should handle that rather than just dropping extra data...
        if ((len(toks) < 24) | (toks[0] != "FT")):
            print('Bad read')
            continue

        # Extract FicTrac variables - see https://github.com/rjdmoore/fictrac/blob/master/doc/data_header.txt
        cnt = int(toks[1])
        dr_cam = [float(toks[2]), float(toks[3]), float(toks[4])]
        err = float(toks[5])
        
        velx = float(toks[6])  # ball velocity about the x axis, i.e. L/R rotation velocity (units = rotation angle/axis in rads), see config image
        vely = float(toks[7])  # ball velocity about the y axis, i.e. fwd/backwards rotation velocity
        velheading = float(toks[8])  # ball velocity about the z axis, i.e. yaw/heading velocity
        
        r_cam = [float(toks[9]), float(toks[10]), float(toks[11])]
        r_lab = [float(toks[12]), float(toks[13]), float(toks[14])]
        
        intx = float(toks[15])  # displacement of the fly in the x direction
        inty = float(toks[16])  # displacement of the fly in the y direction
        heading = float(toks[17])  # integrated heading direction of the animal in lab coords (units = rads, 0-2pi)
        
        heading = float(toks[17])
        step_dir = float(toks[18])
        step_mag = float(toks[19])
        int_forward = float(toks[20]) # Integrated x position (radians) neglecting heading, Equivalent to the output from two optic mice.
        int_side = float(toks[21]) # Integrated y position (radians) neglecting heading, Equivalent to the output from two optic mice.
        ts = float(toks[22])
        seq = int(toks[23])



        # *********** PULL VARIABLES OF INTEREST AND COMPUTE OUTPUT VOLTAGES ***********

        # convert heading from 0-2pi to 0-10V scale
        heading_v = heading % (2 * np.pi) #take difference
        heading_v = heading_v * 10 / (2 * np.pi) #convert to V

        # convert integrated x position from 0-2pi to 0-10V scale
        int_forward_v = int_forward % (2 * np.pi) #take difference
        int_forward_v = int_forward_v * 10 / (2 * np.pi) #convert to V

        # convert integrated y position from 0-2pi to 0-10V scale
        int_side_v = int_side % (2 * np.pi) #take difference
        int_side_v = int_side_v * 10 / (2 * np.pi) #convert to V



        # *********** SEND OUTPUT VARIABLES TO PHIDGET ***********

        aout_yawGain.setVoltage(heading_v)
        aout_int_forward.setVoltage(int_forward_v)
        aout_int_side.setVoltage(int_side_v)
        aout_blank.setVoltage(0.0)



    # *********** COMPLETE AND CLOSE OUTPUTS ***********
    
    # When finished, close outputs (this sets voltages to 0)
    aout_yawGain.close()
    aout_int_forward.close()
    aout_int_side.close()
    aout_blank.close()











