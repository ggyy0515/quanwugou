//
//  ECProductAttrModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAttrModel.h"

@implementation ECProductAttrModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"attrName" : @"attrname",
             @"attrValue" : @"attrvalue"
             };
}

@end
