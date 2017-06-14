//
//  ECMallPanicBuyListModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallPanicBuyListModel.h"

@implementation ECMallPanicBuyListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ids" : @"id",
             @"slogan" : @"slogan",
             @"image" : @"app_proimgurl",
             @"proTable" : @"protable",
             @"activeType" : @"active_type",
             @"endTime" : @"end_time",
             @"originPrice" : @"original_price",
             @"startTime" : @"start_time",
             @"proId" : @"proid",
             @"name" : @"pro_alias",
             @"price" : @"active_price",
             @"leftSecond" : @"SECOND"
             };
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

@end
