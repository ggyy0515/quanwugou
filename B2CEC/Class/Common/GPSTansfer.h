//
//  GPSTansfer.h
//  ZhongShanEC
//
//  Created by Tristan on 16/7/6.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#ifndef GPSTansfer_h
#define GPSTansfer_h

#include <stdio.h>
#include <math.h>

#endif /* GPSTansfer_h */

typedef struct {
    double lng;
    double lat;
} Tristan_location;


 Tristan_location WGS84ToCGJ_02Location(double gg_lat, double gg_lon);



