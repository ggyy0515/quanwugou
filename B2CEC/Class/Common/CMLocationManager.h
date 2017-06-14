//
//  CMLocationManager.h
//  B2CEC
//
//  Created by Tristan on 2016/11/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMLocationManager : NSObject

singleton_interface(CMLocationManager)

/**
 当前定位到的城市(这是实际定位到的城市，不随用户选择别的城市改变)
 */
@property (nonatomic, copy) NSString *currentLocationCityName;
/**
 用户商城模块选择的城市（这是用户选择的城市，展示以这个为准）
 */
@property (nonatomic, copy) NSString *userCityName;
/**
 用户资讯模块选择的城市（这是用户选择的城市，展示以这个为准）
 */
@property (nonatomic, copy) NSString *userNewsCityName;
/**
 用户设计模块选择的城市（这是用户选择的城市，展示以这个为准）
 */
@property (nonatomic, copy) NSString *userDesignerCityName;
/**
 当前纬度
 */
@property (nonatomic, assign) double currentLatitude;
/**
 当前经度
 */
@property (nonatomic, assign) double currentLongitude;
/**
 定位成功后的回调
 */
@property (nonatomic, copy) void(^didUpdateLocation)(double lat, double lng);
/**
 完成请求城市后的回调
 */
@property (nonatomic, copy) void(^didRequestCityInfo)(NSString *cityName);




/**
 触发定位

 @param canRequestCityName 是否允许从网络获取城市
 */
- (void)updateLocationWithCanRequestCityName:(BOOL)canRequestCityName;



@end
