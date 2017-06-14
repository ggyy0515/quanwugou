//
//  WJRegularVerify.m
//  ZhongShanEC
//
//  Created by shuhua on 16/1/8.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import "WJRegularVerify.h"

@implementation WJRegularVerify

+ (BOOL)phoneNumberVerify:(NSString *)str
{
    if (str.length < 1) {
        return NO;
    }
    NSString *regular = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)numberVerify:(NSString *)str
{
    if (str.length < 1) {
        return NO;
    }
    NSString *regular = @"^[0-9]*$";
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)emailVerify:(NSString *)str
{
    if (str.length < 1) {
        return NO;
    }
    NSString *regular = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)spaceVerify:(NSString *)str
{
    if (str.length < 1) {
        return NO;
    }
    NSString *regular = @"(?:^\\s+)|(?:\\s+$)";
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    return [predicate evaluateWithObject:str];
}

+(BOOL)zipcodeVerigy:(NSString *)str
{
    if (str.length < 1) {
        return NO;
    }
    NSString *regular = @"^[1-9][0-9]{5}$";
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)loginNameVerigy:(NSString *)str
{
    if (str.length < 1) {
        return NO;
    }
    NSString *regular = @"^[a-zA-Z0-9_]{6,18}$";
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    return [predicate evaluateWithObject:str];
}
+ (BOOL)onlyContainSpace:(NSString *)str {
    if (str.length < 1) {
        return NO;
    }
    NSString *regular = @"^[\\s　]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    BOOL is = [predicate evaluateWithObject:str];
    return is;
}
@end
