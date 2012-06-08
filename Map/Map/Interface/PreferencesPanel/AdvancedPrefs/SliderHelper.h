//
//  SliderHelper.h
//  Map
//
//  Created by Julian Ceipek on 5/26/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#ifndef Map_SliderHelper_h
#define Map_SliderHelper_h

struct timeUnitTuple {
    float quantity;
    char unit[3];
};

float floatMod(float a, float b);
float *secondsArrayFromTimeUnitTuples(struct timeUnitTuple array[], int length);
float unevenArrayInterp(float curr, float array[], int length);
struct timeUnitTuple timeUnitTupleFromSeconds(float seconds);
char *timeUnitTupleLongForm(struct timeUnitTuple tuple, char* longForm);
char *getPluralChar(float number, char *unit);

#endif
