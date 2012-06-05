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
    int quantity;
    char unit[2];
};

float *secondsArrayFromTimeUnitTuples(struct timeUnitTuple array[], int length);
float unevenArrayInterp(float curr, float array[], int length);

#endif
