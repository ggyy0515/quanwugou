//
//  ECMallFloorProductModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallFloorProductModel.h"

@implementation ECMallFloorProductModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"slogan" : @"slogan",
             @"sort" : @"sort",
             @"image" : @"app_proimgurl",
             @"ids" : @"id",
             @"proId" : @"proid",
             @"floorId" : @"floorid",
             @"proTable" : @"protable",
             @"proName" : @"pro_alias",
             @"price":@"price"
             };
}

@end
