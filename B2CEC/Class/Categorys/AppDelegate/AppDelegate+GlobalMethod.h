//
//  AppDelegate+GlobalMethod.h
//  TrCommerce
//
//  Created by Tristan on 15/11/4.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class EMMessage;

@interface AppDelegate (GlobalMethod)

/**
 获取当前屏幕显示的viewcontroller

 @return vc
 */
- (UIViewController *)getCurrentVC;

/**
 *  召唤登录页
 *
 *  @param vc      控制器
 *  @param isjump  是否退回到TabBar
 *  @param isClear 是否清除当前登录的所有用户信息
 *  @param succeed 完成回调
 */
- (void)callLoginWithViewConcontroller:(UIViewController *)vc
                            jumpToMian:(BOOL)isjump
                 clearCurrentLoginInfo:(BOOL)isClear
                               succeed:(void(^)(void))succeed;

/**
 登录成功之后保存账号信息

 @param resule <#resule description#>
 */
- (void)loginSucceedActionWithRequestResult:(NSDictionary *)resule;

/**
 登出后的操作
 */
- (void)logoutSucceedAction;

/**
 *  删除指定路径的文件
 *
 *  @param path 路径
 */
+ (BOOL)removeFileForPath:(NSString *)path;

/**
 *  推送别名配置
 *
 *  @param oid  oid 
 */
- (void)configPushAlias:(NSString *)oid;

/**
 更新购物车数量缓存
 */
- (void)updateCartNumberCacheFromNetwork;

/**
 注册通知
 */
- (void)registerRemoteNotification;

/**
 *  震动和播放声音
 */
- (void)playSoundAndVibration;

/**
 *  发送本地通知
 *
 *  @param message 环信消息对象
 */
- (void)showNotificationWithMessage:(EMMessage *)message;

@end
