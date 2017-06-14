//
//  ECPointInfoModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointInfoModel.h"

@implementation ECPointInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"frozenPoint":@"frozenPoint",
             @"hasChange":@"haschange",
             @"ids":@"ids",
             @"totalPoint":@"totalpoint",
             @"point":@"point",
             @"rate":@"rate"
             };
}

@end
