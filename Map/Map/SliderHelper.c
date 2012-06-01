//
//  SliderHelper.c
//  Map
//
//  Created by Julian Ceipek on 5/26/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include "SliderHelper.h"

/* 
 Takes an array of timeUnitTuples and computes the amount of seconds to which each
element corresponds. The length of the array must be specified, and the resulting
value will be stored in ret.
*/
void secondsArrayFromTimeUnitTuples(struct timeUnitTuple array[], int length, int ret[]) {    
    for (int i=0; i<length; i++) {
        int multiplier = 0;
        if (strncmp(array[i].unit, "s", 2) == 0) {
            multiplier = 1;
        } else if (strncmp(array[i].unit, "m", 2) == 0){
            multiplier = 60;            
        } else if (strncmp(array[i].unit, "hr", 2) == 0) {
            multiplier = 3600;
        }
        ret[i] = array[i].quantity * multiplier;
    }
}

float linearInterp(float min, float max, float curr, float desMin, float desMax) {
    //float ticks = max - min;
    //float intervals = desMax - desMin; 
    return 4.0f;
}