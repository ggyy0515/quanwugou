//
//  CMNotificationMacro.h
//  TrCommerce
//
//  Created by Tristan on 15/11/4.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#ifndef CMNotificationMacro_h
#define CMNotificationMacro_h

//add notifition
#define POST_NOTIFICATION(NotifationName,obj) [[NSNotificationCenter defaultCenter] postNotificationName: NotifationName object:obj]

//add observer
#define ADD_OBSERVER_NOTIFICATION(id,SEL,Name,obj) [[NSNotificationCenter defaultCenter] addObserver:id selector:SEL name:Name object:obj]

//remove observe
#define REMOVE_NOTIFICATION(id,Name,obj)  [[NSNotificationCenter defaultCenter] removeObserver:id name:Name object:obj]


//noticeName
//咨询分类通知
#define NotificationNewsBeginEditing                            @"NotificationNewsBeginEditing"
#define NotificationNewsChangeState                             @"NotificationNewsChangeState"
#define NOTIFICATION_NAME_PURCHASE_COUNTDOWN                    @"NOTIFICATION_NAME_PURCHASE_COUNTDOWN"
#define NOTIFICATION_NAME_PURCHASE_COUNTDOWN_IN_DETAIL          @"NOTIFICATION_NAME_PURCHASE_COUNTDOWN_IN_DETAIL"
#define NOTIFICATION_NAME_RELOAD_CART_DATA                      @"NOTIFICATION_NAME_RELOAD_CART_DATA"
#define NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA                @"NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA"
#define NOTIFICATION_NAME_RELOAD_ORDER_DETAIL_DATA              @"NOTIFICATION_NAME_RELOAD_ORDER_DETAIL_DATA"
#define NOTIFICATION_DESIGNER_PAY_SUCCESS                       @"NOTIFICATION_DESIGNER_PAY_SUCCESS"
#define NOTIFICATION_NAME_USER_POINT_CHANGED                    @"NOTIFICATION_NAME_USER_POINT_CHANGED"
#define NOTIFICATION_NAME_ADD_BANK_CARD                         @"NOTIFICATION_NAME_ADD_BANK_CARD"
#define NOTIFICATION_NAME_WALLET_BLANCEN_CHANGE                 @"NOTIFICATION_NAME_WALLET_BLANCEN_CHANGE"
#define NOTIFICATION_NEED_RELOAD_MINE_DATA                      @"NOTIFICATION_NEED_RELOAD_MINE_DATA"


//登录成功改变通知
#define NOTIFICATION_USER_LOGIN_SUCCESS                         @"NOTIFICATION_USER_LOGIN_SUCCESS"
//退出登录成功改变通知
#define NOTIFICATION_USER_LOGIN_EXIST                           @"NOTIFICATION_USER_LOGIN_EXIST"
//申请设计师成功改变通知
#define NOTIFICATION_USER_DESIGNER_REGISTER                     @"NOTIFICATION_USER_DESIGNER_REGISTER"
//修改个人资料成功改变通知
#define NOTIFICATION_USER_UPDATE_USERINFO                       @"NOTIFICATION_USER_UPDATE_USERINFO"
//发布日志、文章、作品成功
#define NOTIFICATION_POSTWORKS_LOGS_ARTICLE                     @"NOTIFICATION_POSTWORKS_LOGS_ARTICLE"
//接收到通知消息
#define NOTIFICATION_GET_PUSH                                   @"NOTIFICATION_GET_PUSH"




#endif /* CMNotificationMacro_h */
