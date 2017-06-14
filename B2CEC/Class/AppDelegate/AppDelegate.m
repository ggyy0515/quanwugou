//
//  AppDelegate.m
//  B2CEC
//
//  Created by Tristan on 16/6/30.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "AppDelegate.h"
#import "UPPaymentControl.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()
<
    WXApiDelegate,
    JPUSHRegisterDelegate,
    EMChatManagerDelegate,
    EMClientDelegate
>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //开启日志服务
    _logServer = [[ECLogServer alloc] init];
    [_logServer open];
    [_logServer deleteOldRecord];
    [_logServer insertDetailTableWithInterface:@"appDelegate"
                                          type:type_info
                                          text:@"应用启动"];
    
    if (!EC_USER_WHETHERLOGIN) {
        [self logoutSucceedAction];
    }

    //读取基础参数
    [[CMPublicDataManager sharedCMPublicDataManager] loadPublicDataFromNetwork:NULL];
    //读取作品类型参数
    [[CMWorksTypeDataManager sharedCMWorksTypeDataManager] loadPublicDataFromNetwork:NULL];
    //更新购物车数量
    [self updateCartNumberCacheFromNetwork];
    //更新位置
    [[CMLocationManager sharedCMLocationManager] updateLocationWithCanRequestCityName:YES];
    //控制器
    CMBaseTabBarController *tabBarCtrl = [[CMBaseTabBarController alloc] init];
    self.window.rootViewController = tabBarCtrl;
    //清理搜索缓存
    [AppDelegate removeFileForPath:SEARCHCONDITION_CACHE_PATH];
    //友盟配置
    [self setUMengConfig];
    //极光配置
    [self setJPushConfig:launchOptions];
    
    
    //=================================begin im模块=========================================//
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = HUANXINCERNAME_DEV;
#else
    apnsCertName = HUANXINCERNAME_PRD;
#endif
    EMOptions *options = [EMOptions optionsWithAppkey:HUANXINAPPKEY];
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [self registerRemoteNotification];
    
    //=============================end im模块=============================================//
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //更新位置
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result) return result;
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    if ([url.absoluteString hasPrefix:WEIXINAPPID]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    if ([url.host isEqualToString:@"uppayresult"]) {
        //银联
        [[UPPaymentControl defaultControl] handlePaymentResult:url
                                                 completeBlock:^(NSString *code, NSDictionary *data) {
                                                     //suceess,fail,cancel分别表示支付成功、支付失败和支付取消，data表示结果签名数据，商户使用银联公钥验证结果真实性
                                                     if (_UPPaymentSuccessBlock) {
                                                         _UPPaymentSuccessBlock(code,data);
                                                     }
                                                 }];
        return YES;
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    NSString *bundleIdentifier = [options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([bundleIdentifier isEqualToString:@"com.alipay.iphoneclient"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    else if ([bundleIdentifier isEqualToString:@"com.tencent.xin"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    if ([url.absoluteString rangeOfString:WEIXINAPPID].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.absoluteString rangeOfString:@"com.quanwugou.quanwugou"].location != NSNotFound){
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    return YES;
}
 
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] bindDeviceToken:deviceToken];
        if (error) {
            [_logServer insertDetailTableWithInterface:@"绑定环信推送token失败"
                                                  type:type_debug
                                                  text:error.errorDescription];
        }
        [_logServer insertDetailTableWithInterface:@"绑定环信推送token成功"
                                              type:type_debug
                                              text:@"绑定环信推送token成功"];
    });

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [JPUSHService setBadge:0];
    [application setApplicationIconBadgeNumber:0];
    [_logServer insertDetailTableWithInterface:@"appDelegate"
                                          type:type_info
                                          text:@"启动进入后台"];
    //im
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [JPUSHService setBadge:0];
    [application setApplicationIconBadgeNumber:0];
    
    //更新位置
    [[CMLocationManager sharedCMLocationManager] updateLocationWithCanRequestCityName:NO];
    
    [_logServer insertDetailTableWithInterface:@"appDelegate"
                                          type:type_info
                                          text:@"应用返回前台"];
    //im
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.shuhuasoft.B2CEC" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"B2CEC" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"B2CEC.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark  友盟配置
- (void)setUMengConfig{
    [[UMSocialManager defaultManager] openLog:NO];
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAPPKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEIXINAPPID appSecret:WEIXINAPPSECRET redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:TENCENTAPPID appSecret:TENCENTAPPKEY redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINAAPPKEY  appSecret:SINAAPPSECRET redirectURL:nil];
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]
        ]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知");
        
        [self dealNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound); // 需要执 这个 法，选择 是否提醒 户，有Badge、Sound、Alert三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 后台收到远程通知");
        [self dealNotification:userInfo];
    }
    completionHandler(); // 系统要求执 这个 法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSLog(@"IOS 7 及以上系统，收到通知");
    [self dealNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"IOS 6 以下收到通知");
    [self dealNotification:userInfo];
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)dealNotification:(NSDictionary *)userInfo{
    NSLog(@"推送消息 : %@",userInfo);
    POST_NOTIFICATION(NOTIFICATION_GET_PUSH, nil);
}

#pragma mark  极光配置
- (void)setJPushConfig:(NSDictionary *)launchOptions{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isProduction;
    #if DEBUG
    isProduction = NO;
    #else
    isProduction = YES;
    #endif
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPUSHAPPKEY
                          channel:@"0"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}

- (void)setJPushAlias:(NSString *)alias{
    [JPUSHService setTags:[NSSet set] alias:alias fetchCompletionHandle:nil];
}

#pragma mark - 支付相关

-(void)onResp:(BaseResp *)resp{
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        if (self.WeChatPaySuccessBlock) {
            self.WeChatPaySuccessBlock(resp.errCode);
        }
        switch (resp.errCode) {
            case WXSuccess:{
                [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                                  type:type_info
                                                                  text:@"微信支付结果: 成功"];
                NSLog(@"支付结果: 成功!");
            }
                break;
            case WXErrCodeCommon:{
                [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                                  type:type_info
                                                                  text:@"微信支付结果: 签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等!"];
                NSLog(@"支付结果: 签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等!");
            }
                break;
            case WXErrCodeUserCancel:{
                [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                                  type:type_info
                                                                  text:@"微信支付结果: 用户点击取消并返回!"];
                NSLog(@"支付结果: 用户点击取消并返回!");
            }
                break;
            case WXErrCodeSentFail:{
                [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                                  type:type_info
                                                                  text:@"微信支付结果: 发送失败"];
                NSLog(@"发送失败");
            }
                break;
            case WXErrCodeUnsupport:{
                [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                                  type:type_info
                                                                  text:@"微信支付结果: 微信不支持"];
                NSLog(@"微信不支持");
            }
                break;
            case WXErrCodeAuthDeny:{
                [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                                  type:type_info
                                                                  text:@"微信支付结果: 授权失败"];
                NSLog(@"授权失败");
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - EMChatManagerDelegate

- (void)didReceiveMessages:(NSArray *)aMessages {
    NSLog(@"收到环信聊天消息");
    POST_NOTIFICATION(NOTIFICATION_GET_PUSH, nil);
    [self playSoundAndVibration];
    [self showNotificationWithMessage:[aMessages lastObject]];
}

#pragma mark - EMClientDelegate

- (void)didLoginFromOtherDevice {
    WEAK_SELF
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initFadeAlertWithTitle:@"提示"
                                                                         andText:@"此账号在另别处登录，您被迫下线"
                                                                 andCancelButton:@"确定"
                                                                    forAlertType:AlertFailure
                                                           withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                               UIViewController *vc = [weakSelf getCurrentVC];
                                                               [weakSelf callLoginWithViewConcontroller:vc
                                                                                             jumpToMian:YES
                                                                                  clearCurrentLoginInfo:YES
                                                                                                succeed:^{
                                                                                                    
                                                                                                }];
                                                           }];
    [alert show];
}

@end
