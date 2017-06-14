//
//  ECMallHouseModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallHouseModel.h"

@implementation ECMallHouseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name" : @"NAME",
             @"code" : @"BIANMA",
             @"image" : @"ICON",
             @"orderBy" : @"PARENT_ID"
             };
}


@end
