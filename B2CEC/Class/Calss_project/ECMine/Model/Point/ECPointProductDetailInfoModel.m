//
//  ECPointProductDetailInfoModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointProductDetailInfoModel.h"

@implementation ECPointProductDetailInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"ids":@"id",
             @"point":@"integral",
             @"stock":@"stock",
             @"name":@"proname",
             @"detail":@"details"
             };
}

@end
