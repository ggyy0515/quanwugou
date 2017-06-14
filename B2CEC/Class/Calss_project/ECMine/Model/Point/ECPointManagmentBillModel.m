//
//  ECPointManagmentBillModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointManagmentBillModel.h"

@implementation ECPointManagmentBillModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"createDate":@"createdateStr",
             @"ids":@"ids",
             @"source":@"source",
             @"detail":@"detail",
             @"point":@"point",
             @"symbolPoint":@"symbolpoint",
             @"image":@"imgurl"
             };
}


@end
