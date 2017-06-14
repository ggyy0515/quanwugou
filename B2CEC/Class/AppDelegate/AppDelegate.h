//
//  AppDelegate.h
//  B2CEC
//
//  Created by Tristan on 16/6/30.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "ECLogServer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong) ECLogServer *logServer;

/*!
 *  微信支付回调
 */
@property (nonatomic, copy) void (^WeChatPaySuccessBlock)(int);
/**
 银联支付回调
 */
@property (nonatomic, copy) void (^UPPaymentSuccessBlock)(NSString * ,NSDictionary *);
/**
 *  最近一次播放声音的时间
 */
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
//设置激光推送别名
- (void)setJPushAlias:(NSString *)alisa;

@end

