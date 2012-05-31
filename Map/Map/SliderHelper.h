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

void secondsArrayFromTimeUnitTuples(struct timeUnitTuple array[], int length, int ret[]);
float linearInterp(float min, float max, float curr, float desMin, float desMax);

#endif