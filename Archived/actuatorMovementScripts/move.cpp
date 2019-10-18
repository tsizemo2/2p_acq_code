//#include "stdafx.h"
#include <stdio.h>
#include <windows.h>
#include <conio.h>
#include <cstdio>
#include <cstdlib>

//#if defined TestCode
//    #include
#include "C:\Users\wilson_lab\Desktop\Michael\actuatorMovementScripts\Thorlabs.MotionControl.KCube.DCServo.h"
//#else
//    #include "Thorlabs.MotionControl.KCube.DCServo.h"
//#endif
//namespace KDC_Console
//{
    int main(int argc, char* argv[]) // serialNum, position
    {
        
        // Give instructions if function was called without enough arguments
        if(argc < 4)
        {
            printf("Usage = Example_KDC101 [serial number] [position: (0 - 435000)] [delay period (msec)]\r\n");
            return 1;
        }
        
        // Process input arguments
        char* serialNumChar = argv[1];
//        char* realPosChar = argv[2];
//        float realPosition;
//        sscanf(realPosChar, "%e", &realPosition);
//        printf("Requested real unit pos = %e\n", realPosition);
        char* movePosChar = argv[2];
        float movePos;
        sscanf(movePosChar, "%e", &movePos);
        char* delayChar = argv[3];
        int delayLen;
        sscanf(delayChar, "%d", &delayLen);
        printf("Requested move to %s after a delay of %s msec\n", movePosChar, delayChar);     
        
        //wait for the specified amount of time before moving actuator
        Sleep(delayLen);  
        
        // open device
        int devOpen = CC_Open(serialNumChar);
        if(devOpen == 0)
        {
            
            TLI_BuildDeviceList();            
            
            // Make sure the actuator doesn't need to be homed
            bool moveWithoutHoming;
            moveWithoutHoming = CC_CanMoveWithoutHomingFirst(serialNumChar);
            if(moveWithoutHoming == false)
            {    
                printf("Error: device needs to be homed before moving");
                return 1;
            }
            
            // get starting position
            int startPos = CC_GetPosition(serialNumChar);
            printf("Device initial position = %d\r\n", startPos);
            
            // start the device polling at 200ms intervals
            CC_StartPolling(serialNumChar, 200); 
            
            // move to position (channel 1)
            CC_ClearMessageQueue(serialNumChar);
            CC_MoveToPosition(serialNumChar, movePos);
            printf("Device moving\r\n");
            
            // wait for completion
            WORD messageType;
            WORD messageId;
            DWORD messageData;
            CC_WaitForMessage(serialNumChar, &messageType, &messageId, &messageData);

            while(messageType != 2 || messageId != 1)
            {
                CC_WaitForMessage(serialNumChar, &messageType, &messageId, &messageData);
            }
            
            // get actual position
            int newPos = CC_GetPosition(serialNumChar);
            printf("Device moved to %d\r\n\n\n", newPos);
            
            // stop polling
            CC_StopPolling(serialNumChar);\
            
            // close device
            CC_Close(serialNumChar);
        }
        //printf("Press any key to continue");
        //_getch();
        return devOpen;
    }
//}