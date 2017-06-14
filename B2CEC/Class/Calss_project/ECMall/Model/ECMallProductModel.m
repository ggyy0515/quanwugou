//
//  ECMallProductModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallProductModel.h"

@implementation ECMallProductModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"proId" : @"proid",
             @"image" : @"imgurl",
             @"name" : @"proname",
             @"price" : @"price",
             @"protable":@"protable",
             @"collect_id":@"collect_id"
             };
}

@end
