
//
//  ECMaterialLibraryModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMaterialLibraryModel.h"

@implementation ECMaterialLibraryModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"createtime":@"createtime",
             @"libID":@"id",
             @"style":@"style",
             @"descri":@"descri",
             @"isCollect":@"isCollect",
             @"type":@"type",
             @"url":@"url",
             @"collect":@"collect"
             };
}
@end
