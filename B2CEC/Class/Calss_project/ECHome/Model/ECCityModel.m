//
//  ECCityModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCityModel.h"

@implementation ECCityModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"NAME" : @"NAME",
             @"BIANMA" : @"BIANMA",
             @"subDict" : @"subDict"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"subDict" : [ECCityModel class]
             };
}

@end
