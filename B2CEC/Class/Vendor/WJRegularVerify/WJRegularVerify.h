//
//  WJRegularVerify.h
//  ZhongShanEC
//
//  Created by shuhua on 16/1/8.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//
//  正则表达式校验类

#import <Foundation/Foundation.h>

@interface WJRegularVerify : NSObject
/**
 *  手机号码校验
 *
 *  @param str
 *
 *  @return 是否通过校验
 */
+ (BOOL)phoneNumberVerify:(NSString *)str;

/**
 *  数字校验
 *
 *  @param str
 *
 *  @return 是否通过校验
 */
+ (BOOL)numberVerify:(NSString *)str;

/**
 *  邮箱校验
 *
 *  @param str
 *
 *  @return 是否通过校验
 */
+ (BOOL)emailVerify:(NSString *)str;

/**
 *  空格字符串校验
 *
 *  @param str
 *
 *  @return 是否通过校验
 */
+ (BOOL)spaceVerify:(NSString *)str;

/**
 *  邮政编码校验
 *
 *  @param str
 *
 *  @return 是否通过校验
 */
+ (BOOL)zipcodeVerigy:(NSString *)str;

/**
 *  登录用户名校验
 *
 *  @param str 是否校验通过
 *
 *  @return 
 */
+ (BOOL)loginNameVerigy:(NSString *)str;

/**
 *  是否只包含空格
 *
 *  @param str
 *
 *  @return
 */
+ (BOOL)onlyContainSpace:(NSString *)str;

@end
