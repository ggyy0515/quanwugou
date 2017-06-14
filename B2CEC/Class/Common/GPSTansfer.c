//
//  GPSTansfer.c
//  ZhongShanEC
//
//  Created by Tristan on 16/7/6.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#include "GPSTansfer.h"


const double x_pi = 3.1415926535897932384626; //* 3000.0 / 180.0;
const double x_a = 6378245.0;
const double x_ee = 0.00669342162296594323;



double transformLat(double x, double y) {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * x_pi) + 20.0 * sin(2.0 * x * x_pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * x_pi) + 40.0 * sin(y / 3.0 * x_pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * x_pi) + 320 * sin(y * x_pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transformLon(double x, double y) {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * x_pi) + 20.0 * sin(2.0 * x * x_pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * x_pi) + 40.0 * sin(x / 3.0 * x_pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * x_pi) + 300.0 * sin(x / 30.0 * x_pi)) * 2.0 / 3.0;
    return ret;
}  



 Tristan_location WGS84ToCGJ_02Location(double gg_lat, double gg_lon) {
    
    double dLat = transformLat(gg_lon - 105.0, gg_lat - 35.0);
    double dLon = transformLon(gg_lon - 105.0, gg_lat - 35.0);
    double radLat = gg_lat / 180.0 * x_pi;
    double magic = sin(radLat);
    magic = 1 - x_ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((x_a * (1 - x_ee)) / (magic * sqrtMagic) * x_pi);
    dLon = (dLon * 180.0) / (x_a / sqrtMagic * cos(radLat) * x_pi);
    double mgLat = gg_lat + dLat;
    double mgLon = gg_lon + dLon;

    Tristan_location location;
    location.lat = mgLat;
    location.lng = mgLon;
    return location;
}



