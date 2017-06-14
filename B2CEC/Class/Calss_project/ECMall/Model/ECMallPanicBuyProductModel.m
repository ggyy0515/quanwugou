//
//  ECMallPanicBuyProductModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallPanicBuyProductModel.h"

@implementation ECMallPanicBuyProductModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ids" : @"id",
             @"proName" : @"pro_alias",
             @"price" : @"active_price",
             @"slogan" : @"slogan",
             @"proTable" : @"protable",
             @"proId" : @"proid",
             @"startTimeStr" : @"start_time",
             @"activeType" : @"active_type",
             @"endTimeStr" : @"end_time",
             @"sort" : @"sort",
             @"image" : @"app_proimgurl",
             @"originPrice" : @"original_price"
             };
}

@end
