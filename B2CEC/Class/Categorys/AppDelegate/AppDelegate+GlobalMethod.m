//
//  AppDelegate+GlobalMethod.m
//  TrCommerce
//
//  Created by Tristan on 15/11/4.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "AppDelegate+GlobalMethod.h"
#import "ECLoginViewController.h"

#import "EMMessage.h"

static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";


@implementation AppDelegate (GlobalMethod)

#pragma mark - Method

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)callLoginWithViewConcontroller:(UIViewController *)vc
                            jumpToMian:(BOOL)isjump
                 clearCurrentLoginInfo:(BOOL)isClear
                               succeed:(void(^)(void))succeed {
    if (isClear) {
        [self logoutSucceedAction];
    }
    ECLoginViewController *loginVc = [ECLoginViewController new];
    CMBaseNavigationController *loginNav = [[CMBaseNavigationController alloc] initWithRootViewController:loginVc];
    [self.window.rootViewController presentViewController:loginNav animated:YES completion:^{
        if (isjump) {
            [vc.navigationController popToRootViewControllerAnimated:YES];
            [((CMBaseTabBarController *)APP_DELEGATE.window.rootViewController) setSelectedIndex:0];
        }
        succeed();
    }];
}

- (void)loginSucceedActionWithRequestResult:(NSDictionary *)result{
    [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                      type:type_info
                                                      text:@"用户登录成功，开始保存基本信息，并登录环信"];
    //keychain
    [Keychain setObject:result[@"info"][@"USER_ID"] forKey:EC_USER_ID];
    [Keychain setObject:result[@"info"][@"USERNAME"] forKey:EC_USER_LOGINNAME];
    [Keychain setObject:result[@"info"][@"PHONE"] forKey:EC_PHONE];
    [Keychain setObject:result[@"info"][@"USERINFO_ID"] forKey:EC_USERINFO_ID];
    [Keychain setObject:result[@"secret"] forKey:EC_SECRET];
    //UserDefaults
    [USERDEFAULT setObject:result[@"info"][@"AGE"] forKey:EC_USER_AGE];
    [USERDEFAULT setObject:result[@"info"][@"SEX"] forKey:EC_USER_SEX];
    [USERDEFAULT setObject:result[@"info"][@"NAME"] forKey:EC_USER_NICKNAME];
    [USERDEFAULT setObject:result[@"info"][@"TITLE_IMG"] forKey:EC_USER_HEAD_IMAGE];
    [USERDEFAULT setObject:result[@"info"][@"DISSTATE"] forKey:EC_USER_DISSTATE];
    [USERDEFAULT setObject:result[@"info"][@"DISCODE"] forKey:EC_USER_DISCODE];
    [USERDEFAULT setObject:result[@"info"][@"ISDIS"] forKey:EC_USER_ISDIS];
    [USERDEFAULT setObject:result[@"info"][@"PARENTDISCODE"] forKey:EC_USER_PARENTDISCODE];
    [USERDEFAULT setObject:result[@"info"][@"ISSETPAYWD"] forKey:EC_USER_ISSETPAYWD];
    [USERDEFAULT setObject:result[@"info"][@"RIGHTS"] forKey:EC_USER_STATUS];
    
    [USERDEFAULT setBool:YES forKey:EC_ISLOGIN_FLAG];
    
    if ([USERDEFAULT boolForKey:EC_ALLOW_RECEIVE_PUSH]) {
        [APP_DELEGATE setJPushAlias:[Keychain objectForKey:EC_USER_ID]];
    }
    
    //发送登录状态改变通知
    POST_NOTIFICATION(NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    
    //更新购物车数量
    [self updateCartNumberCacheFromNetwork];
    
    //im登录
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:result[@"info"][@"USER_ID"]
                                                           password:HUANXIN_LOGIN_PASSWORD];
        if (error) {
            ECLog(@"环信登录错误：%@", error.errorDescription);
            [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                              type:type_error
                                                              text:[NSString stringWithFormat:@"登录环信发生错误%@", error.errorDescription]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                //获取数据库中数据
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] dataMigrationTo3];
                });
            }
            
        });
        
    });
}

- (void)logoutSucceedAction {
    [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                      type:type_info
                                                      text:@"用户退出登录成功，开始删除基本信息，并退出环信"];
    //keychain
    [Keychain removeObjectForKey:EC_USER_ID];
    [Keychain removeObjectForKey:EC_USER_LOGINNAME];
    [Keychain removeObjectForKey:EC_PHONE];
    [Keychain removeObjectForKey:EC_USERINFO_ID];
    [Keychain removeObjectForKey:EC_SECRET];
    //UserDefaults
    [USERDEFAULT removeObjectForKey:EC_USER_AGE];
    [USERDEFAULT removeObjectForKey:EC_USER_SEX];
    [USERDEFAULT removeObjectForKey:EC_USER_NICKNAME];
    [USERDEFAULT removeObjectForKey:EC_USER_HEAD_IMAGE];
    [USERDEFAULT removeObjectForKey:EC_USER_DISSTATE];
    [USERDEFAULT removeObjectForKey:EC_USER_DISCODE];
    [USERDEFAULT removeObjectForKey:EC_USER_ISDIS];
    [USERDEFAULT removeObjectForKey:EC_USER_PARENTDISCODE];
    [USERDEFAULT removeObjectForKey:EC_USER_ISSETPAYWD];
    [USERDEFAULT removeObjectForKey:EC_USER_STATUS];
    
    [USERDEFAULT setBool:NO forKey:EC_ISLOGIN_FLAG];
    
    //清空购物车数量
    [CMPublicDataManager sharedCMPublicDataManager].cartNumber = 0;
    
    //退出时置空推送别名
    [APP_DELEGATE setJPushAlias:@""];
    
    //发送登录状态改变通知
    POST_NOTIFICATION(NOTIFICATION_USER_LOGIN_EXIST, nil);
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] logout:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error != nil) {
                    ECLog(@"环信登出失败  %@", error.errorDescription);
                    [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                                      type:type_error
                                                                      text:[NSString stringWithFormat:@"退出环信发生错误%@", error.errorDescription]];
                } else {
    
                }
            });
        });
}


+ (BOOL)removeFileForPath:(NSString *)path{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:&error];
        if (!error) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 推送别名配置
- (void)configPushAlias:(NSString *)oid{
    ECLog(@"别名:   %@",oid);
//    [APService setTags:nil alias:oid callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}


- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias{
    
    ECLog(@"配置推送别名回调-----%d",iResCode);
    
}

- (void)updateCartNumberCacheFromNetwork {
    if (EC_USER_WHETHERLOGIN) {
        [ECHTTPServer requestCartNumberWithUserId:[Keychain objectForKey:EC_USER_ID]
                                          succeed:^(NSURLSessionDataTask *task, id result) {
                                              if (IS_REQUEST_SUCCEED(result)) {
                                                  NSInteger count = [result[@"count"] integerValue];
                                                  [CMPublicDataManager sharedCMPublicDataManager].cartNumber = count;
                                              }
                                          }
                                           failed:^(NSURLSessionDataTask *task, NSError *error) {
                                               
                                           }];
    }
}


- (void)registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

- (void)playSoundAndVibration {
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        ECLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}




- (void)showNotificationWithMessage:(EMMessage *)message {
    {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        
        
        if (message.body.type == EMMessageBodyTypeText) {
            notification.alertBody = ((EMTextMessageBody *)message.body).text;
        } else {
            notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
        }
        
        
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
        if (timeInterval < kDefaultPlaySoundInterval) {
            ECLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        } else {
            notification.soundName = UILocalNotificationDefaultSoundName;
            self.lastPlaySoundDate = [NSDate date];
        }
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
        [userInfo setObject:message.conversationId forKey:kConversationChatter];
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        UIApplication *application = [UIApplication sharedApplication];
        application.applicationIconBadgeNumber += 1;
    }
}

@end
