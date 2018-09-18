//#include "stdafx.h"
#include <stdio.h>
#include <windows.h>
#include <conio.h>
#include <cstdio>

//#if defined TestCode
//    #include
#include "C:\Users\wilson_lab\Desktop\Michael\actuatorMovementScripts\Thorlabs.MotionControl.KCube.DCServo.h"
//#else
//    #include "Thorlabs.MotionControl.KCube.DCServo.h"
//#endif
//namespace KDC_Console


//serialNum = 27002275

int main(int argc, char* argv[]) // serialNum, position
{
    
    // Give instructions if function was called without enough arguments
    if(argc < 2)
    {
        printf("Usage = Example_KDC101 [serial number]\r\n");
        return 1;
    }
    
    // Process input arguments
    char* serialNumChar = argv[1];
    printf("%s\n", serialNumChar);
    
//        printf("hello world\n");
//        char buffer [50];
//        sprintf(buffer, "%s", argv[1]);
//        printf("%s\n", buffer);
    
//        float test;
//        sscanf(argv[1], "%e", &test);
    
//        char argcChar[16];
//        sprintf(argcChar, "%d", argc);
//        printf("%s\n", argcChar);

    // identify and access device
//        int serialNumInt = 12345678;
//        char serialNumChar[16];
//        sprintf(serialNumChar, "%d", serialNumInt);

    CC_Close(serialNumChar);        
    
//        // Get device list
//        printf("building device list\n");
//        if (TLI_BuildDeviceList() == 0)
//        {
//            printf("Getting device list size\n");
//            int n = TLI_GetDeviceListSize();
//            printf("list size = %d\n", n);
//            printf("Getting device list by type\n");
//            char serialNums[250];
//            TLI_GetDeviceListByTypeExt(serialNums, 250, 27);
//            printf("Type list = %s\n", serialNums);
//            char *p = strtok(serialNums, ",");
//            TLI_DeviceInfo deviceInfo;
//            TLI_GetDeviceInfo(p, &deviceInfo);
//            char serialNo[9];
//            strncpy(serialNo, deviceInfo.serialNo, 8);
//            serialNo[8] = '\0';
//            printf("%s\n", serialNo);
//        }

    // open device
    if (CC_Open(serialNumChar) == 0)
    {
        printf("Device opened\n");
           
        // start the device polling at 200ms intervals
        CC_StartPolling(serialNumChar, 200);
        Sleep(300);
        
        // get starting position
        int startPos = CC_GetPosition(serialNumChar);
        printf("Device #%s is at position %d\r\n", serialNumChar, startPos);
        
        // home device
        CC_ClearMessageQueue(serialNumChar);
        CC_Home(serialNumChar);
        printf("Device %s homing\r\n", serialNumChar);
               
        // wait for completion
        WORD messageType;
        WORD messageId;
        DWORD messageData;
        CC_WaitForMessage(serialNumChar, &messageType, &messageId, &messageData);
        while(messageType != 2 || messageId !=0)
        {
            CC_WaitForMessage(serialNumChar, &messageType, &messageId, &messageData);
        }
            

     
//        bool complete = false;
//        while(!complete)
//        {
//            while(CC_MessageQueueSize((serialNumChar)) == 0)
//            {
//                Sleep(100);
//            }
//        }
//                    
//        // wait for completion
//        WORD messageType;
//        WORD messageId;
//        DWORD messageData;
//        CC_GetNextMessage(serialNumChar,  &messageType, &messageId, &messageData);
    
        
        
//        CC_WaitForMessage(serialNumChar, &messageType, &messageId, &messageData);
//        while(messageType != 3 || messageId != 1)
//        {
//            CC_WaitForMessage(serialNumChar, &messageType, &messageId, &messageData);
//        }
//        
        // get new poaition
        int pos = CC_GetPosition(serialNumChar);
        printf("Device %s moved to %d\r\n", serialNumChar, pos);
        
        // stop polling
        CC_StopPolling(serialNumChar);\
        
        // close device
        CC_Close(serialNumChar);
        printf("Device closed");
    }
    return 0;
}
