//
//  NSString+Addtions.h
//  ZhongShanEC
//
//  Created by 曙华国际 on 16/4/26.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addtions)

/*!
 *  检验用户名是否合法
 *  规则：使用正则校验一下：中英字、数字、下划线。
 *  @return YES/NO;
 */
- (BOOL)checkUserName;


/**
 *  校验登录密码是否合法
 *
 *  @return 
 */
- (BOOL)checkLoginPassword;

- (BOOL)checkBankCardOwner;


@end
