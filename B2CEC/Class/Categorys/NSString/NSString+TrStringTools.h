//
//  NSString+TrStringTools.h
//  TrCommerce
//
//  Created by Tristan on 15/11/3.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TrStringTools)

/**
 *  UTF-8编码
 *
 *  @return
 */
- (NSString *)urlEncodedUTF8String;


/**
 *  计算高度
 *
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return
 */
- (CGFloat)computeTextHeightWith:(UIFont *)font withWidth:(CGFloat )width;


/**
 *  替换字符
 *
 *  @param formerStr 原字符
 *  @param nowStr    新字符
 *
 *  @return
 */
- (NSString *)replaceCharacter:(NSString *)formerStr withCharacter:(NSString *)nowStr;


/**
 *  从字典中取出字符串，加判空
 *
 *  @param key key
 *  @param dic dic
 *
 *  @return
 */
+ (NSString *)getValueWithKey:(NSString *)key inDictonary:(NSDictionary *)dic;

@end
