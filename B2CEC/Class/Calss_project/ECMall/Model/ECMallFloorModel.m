//
//  ECMallFloorModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallFloorModel.h"
#import "ECMallFloorProductModel.h"

@implementation ECMallFloorModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"floorSort" : @"floor_sort",
             @"image" : @"top_banner_url",
             @"ids" : @"id",
             @"floorName" : @"floor_name",
             @"productList" : @"floorProduct",
             @"brand":@"pinpai",
             @"attrCode":@"attrcode",
             @"attrValue":@"attrvalue",
             @"code":@"bianma"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"productList" : [ECMallFloorProductModel class]
             };
}


@end
