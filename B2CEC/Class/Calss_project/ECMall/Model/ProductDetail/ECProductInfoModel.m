//
//  ECProductInfoModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductInfoModel.h"

@implementation ECProductInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"serise" : @"series",
             @"isDiscount" : @"isdiscount",
             @"proId" : @"proid",
             @"proTable" : @"protable",
             @"name" : @"proname",
             @"period" : @"period",
             @"saleNumber" : @"salenumber",
             @"isCollect" : @"iscollect",
             @"point" : @"point",
             @"price" : @"price",
             @"isEasePay" : @"iseasypay",
             @"area":@"area",
             @"appraiseNum":@"commentNum",
             @"stock":@"stock",
             @"leftSecond":@"active_duration",
             @"isPanicBuy":@"audit_state",
             @"actPrice":@"active_price",
             @"isLeftProduct":@"isleftover",
             @"factoryUserId":@"seller_id"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (!dic[@"isdiscount"]) {
        _isDiscount = @"1";
    }
    return YES;
}

- (void)countDown {
    _leftSecond --;
}

- (NSString *)currentTimeString {
    if (_leftSecond <= 0) {
        return @"已结束";
    } else {
        if (_leftSecond > 86400) {
            return [NSString stringWithFormat:@"%ld天 %02ld:%02ld:%02ld", _leftSecond/86400, _leftSecond%86400/3600, _leftSecond%86400%3600/60, _leftSecond%60];
        } else {
            return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_leftSecond/3600,_leftSecond%3600/60,_leftSecond%60];
        }
    }
}

- (NSString *)getDay {
    if (_leftSecond > 86400) {
        return [NSString stringWithFormat:@"%ld天", _leftSecond/86400];
    } else {
        return @"";
    }
}

- (NSString *)getHour {
    if (_leftSecond > 86400) {
        return [NSString stringWithFormat:@"%02ld", _leftSecond%86400/3600];
    } else {
        return [NSString stringWithFormat:@"%02ld", _leftSecond/3600];
    }
}

- (NSString *)getMinute {
    if (_leftSecond > 86400) {
        return [NSString stringWithFormat:@"%02ld", _leftSecond%86400%3600/60];
    } else {
        return [NSString stringWithFormat:@"%02ld", _leftSecond%3600/60];
    }
}

- (NSString *)getSecond {
    return [NSString stringWithFormat:@"%02ld", _leftSecond%60];
    
}

@end
