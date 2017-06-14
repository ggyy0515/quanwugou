//
//  NSString+Addtions.m
//  ZhongShanEC
//
//  Created by 曙华国际 on 16/4/26.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import "NSString+Addtions.h"

@implementation NSString (Addtions)
/*!
 *  检验用户名是否合法
 *  规则：使用正则校验一下：中英字、数字、下划线。
 *  @return YES/NO;
 */
-(BOOL)checkUserName
{
    
    NSString *pureChineseRegex =@"^[\u4e00-\u9fa5]{2,}$";
    NSPredicate *pureChinesepredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pureChineseRegex];
    BOOL isPureValid = [pureChinesepredicate evaluateWithObject:self];
    
    if (isPureValid) {
        //纯汉字2个汉字以上
        return YES;
    }
    
    
    NSString *regex = @"^[\u4e00-\u9fa5A-Z0-9a-z._%+-]{3,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)checkLoginPassword {
    NSString *regex = @"[a-zA-Z0-9_]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

- (BOOL)checkBankCardOwner {
    NSString *regex = @"^[^ ]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self];
    return isValid;
}

@end
