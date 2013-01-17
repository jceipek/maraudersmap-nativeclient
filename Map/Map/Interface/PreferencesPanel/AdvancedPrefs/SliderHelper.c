//
//  SliderHelper.c
//  Map
//
//  Created by Julian Ceipek on 5/26/12.
//  Copyright (c) 2012-2013 ohack. All rights reserved.
//

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "SliderHelper.h"

/* 
 Takes an array of timeUnitTuples and computes the amount of seconds to which each
element corresponds. The length of the array must be specified, and the resulting
value will be stored in ret.
*/
float *secondsArrayFromTimeUnitTuples(struct timeUnitTuple *array, int length) {   
    float *ret = malloc(length * sizeof(float));
    if (ret == NULL) {
        return NULL;
    }
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
    return ret;
}

float floatMod(float a, float b) {
    int result = (int)(a/b);
    return a - (float)result * b;
}

/* Takes in a ratio float between 0 and 1 and returns a float based on a linear interpolation
 between two values of an input array of a given length such that the indicies of
 those values are the closest to the input float in terms of ratio. 
 
 For example, consider the input 0.6; [0, 100, 1000]; 3.
 The closest indicies to ratio value 0.6 are 1 and 2, for ratio values 0.5 and 1.0, respectively
 Then...
 100  = m*0.5 + b
 1000 = m*1.0 + b
 
 100 - 1000 = m*0.5 - m*1.0 + b-b
 -900 = -0.5 * m
 1800 = m
 
 1000 - 1800 * 1.0 = b = -800
 
 1800 * 0.6 + -800 = 280
 
 return value is thus 280
*/
float unevenArrayInterp(float curr, float *array, int length) {
    length -= 1;
    float tweenRatio = floatMod(curr, (1.0f/length)) * length;
    int lowerIndex = (int)(length * curr);
    int upperIndex = (int)(length * curr + 0.9f);
    
    return ((array[upperIndex] - array[lowerIndex]) * tweenRatio) + array[lowerIndex];
}

struct timeUnitTuple timeUnitTupleFromSeconds(float seconds) {
    struct timeUnitTuple retTuple;
    if (seconds >= 3600) {
        float hours = seconds/3600.0f;
        retTuple.quantity = hours;
        strcpy(retTuple.unit, "hr");
        return retTuple;
    } else if (seconds >= 60) {
        float minutes = seconds/60.0f;
        retTuple.quantity = minutes;
        strcpy(retTuple.unit, "m");
        return retTuple;
    } else {
        retTuple.quantity = seconds;
        strcpy(retTuple.unit, "s");
        return retTuple;
    }
}

char *timeUnitTupleLongForm(struct timeUnitTuple tuple, char* longForm) {
    char *pluralizedUnit;
    if (strncmp(tuple.unit, "s", 2) == 0) {
        pluralizedUnit = getPluralChar(tuple.quantity, "second");
        sprintf(longForm, "%.0f %s", tuple.quantity, pluralizedUnit);
        free(pluralizedUnit);
    } else if (strncmp(tuple.unit, "m", 2) == 0){
        pluralizedUnit = getPluralChar(tuple.quantity, "minute");
        sprintf(longForm, "%.0f %s", tuple.quantity, pluralizedUnit);    
        free(pluralizedUnit);
    } else if (strncmp(tuple.unit, "hr", 2) == 0) {
        pluralizedUnit = getPluralChar(tuple.quantity, "hour");
        sprintf(longForm, "%.0f %s", tuple.quantity, pluralizedUnit);
        free(pluralizedUnit);
    }
    return longForm;
}

char *getPluralChar(float number, char *unit) {
    int length = (int)strlen(unit);
    char *retUnit = malloc((length + 2) * sizeof(char));
    if ((int)(number + 0.5) > 1) {
        sprintf(retUnit, "%ss", unit);
        return retUnit;
    } else {
        sprintf(retUnit, "%s", unit);
        return retUnit;
    }
}
