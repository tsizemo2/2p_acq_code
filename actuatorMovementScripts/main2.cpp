#include <stdio.h>
#include "C:\Users\Wilson Lab\Documents\MATLAB\actuatorMovementScripts\Thorlabs.MotionControl.KCube.DCServo.h"

int main(int argc, char **argv)
{
	//printf("hello world\n");
    
    char test[4];
    sprintf(test, "%s", "test");

    
    printf("test1 %s \n", test);
    
    
    char m = *argv[1];
    _tmain(argc, &m);
    
	return 0;
}
