//
//  CMLocationManager.m
//  B2CEC
//
//  Created by Tristan on 2016/11/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "CMLocationManager.h"
#import "GPSTansfer.h"

@interface CMLocationManager ()
<
    CLLocationManagerDelegate
>

@property (nonatomic, strong) CLLocationManager *locationManager;
/**
 是否允许从网络读取城市信息,用以限制定位多次返回
 */
@property (nonatomic, assign) BOOL canRequestCityName;


@end

@implementation CMLocationManager

singleton_implementation(CMLocationManager)

#pragma mark - Setter & Getter

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    return _locationManager;
}

#pragma mark - Actions

/**
 更新当前城城市信息：根据上一次更新的坐标，从网络获取当前城市信息，并更新currentLocationCityName，userCityName
 
 @param succeed 成功回调
 *//*
- (void)locateCurrentCitySucceed:(void (^)(NSString *, double, double))succeed {
    [ECHTTPServer requestCityNameWithLng:_currentLongitude
                                     lat:_currentLatitude
                                 succeed:^(NSURLSessionDataTask *task, id result) {
                                     if (IS_REQUEST_SUCCEED(result)) {
                                         ECLog(@"%@", result);
                                     } else {
                                         EC_SHOW_REQUEST_ERROR_INFO
                                     }
                                 }
                                  failed:^(NSURLSessionDataTask *task, NSError *error) {
                                      RequestFailure
                                  }];
}*/


- (void)getCurrentLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }else{
        if (_didRequestCityInfo) {
            _didRequestCityInfo(@"");
        }
        [SVProgressHUD showInfoWithStatus:@"无法获取当前位置，请开启定位功能"];
    }
    
}

- (void)updateLocationWithCanRequestCityName:(BOOL)canRequestCityName {
    _canRequestCityName = canRequestCityName;
    [self getCurrentLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    ECLog(@"经纬度获取成功");
    ECLog(@"纬度:%f",newLocation.coordinate.latitude);
    ECLog(@"经度:%f",newLocation.coordinate.longitude);
    Tristan_location location = WGS84ToCGJ_02Location (newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    ECLog(@"纬度修正:%lf",location.lat);
    ECLog(@"经度修正:%lf",location.lng);
    _currentLatitude = location.lat;
    _currentLongitude = location.lng;
    
    [self.locationManager stopUpdatingLocation];
    if (_didUpdateLocation) {
        _didUpdateLocation(_currentLatitude, _currentLongitude);
    }
    if (_canRequestCityName) {
        _canRequestCityName = NO;
        [ECHTTPServer requestCityNameWithLng:_currentLongitude
                                         lat:_currentLatitude
                                     succeed:^(NSURLSessionDataTask *task, id result) {
                                         if (IS_REQUEST_SUCCEED(result)) {
                                             _currentLocationCityName = result[@"city"];
                                             _userCityName = result[@"city"];
                                             _userNewsCityName = result[@"city"];
                                             _userDesignerCityName = result[@"city"];
                                             ECLog(@"%@", result);
                                         } else {
                                             EC_SHOW_REQUEST_ERROR_INFO
                                             _currentLocationCityName = @"";
                                             _userCityName = @"";
                                             _userNewsCityName = @"";
                                             _userDesignerCityName = @"";
                                         }
                                         if (_didRequestCityInfo) {
                                             _didRequestCityInfo(_currentLocationCityName);
                                         }
                                     }
                                      failed:^(NSURLSessionDataTask *task, NSError *error) {
                                          RequestFailure
                                          _currentLocationCityName = @"";
                                          _userCityName = @"";
                                          _userNewsCityName = @"";
                                          _userDesignerCityName = @"";
                                          if (_didRequestCityInfo) {
                                              _didRequestCityInfo(_currentLocationCityName);
                                          }
                                      }];
    }

}


@end
