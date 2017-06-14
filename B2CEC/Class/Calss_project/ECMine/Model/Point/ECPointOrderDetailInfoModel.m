//
//  ECPointOrderDetailInfoModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointOrderDetailInfoModel.h"

@implementation ECPointOrderDetailInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"orderNo":@"orderno",
             @"tradeNo":@"tranno",
             @"point":@"total_amount",
             @"userName":@"user_name",
             @"mobile":@"mobile",
             @"receiver":@"receiver",
             @"address":@"address",
             @"express":@"express",
             @"expressNumber":@"expressnumber",
             @"state":@"state",
             @"createDate":@"createdate",
             @"message":@"message",
             @"proName":@"proname",
             @"count":@"proqty",
             @"expressCode":@"expresscode",
             @"orderId":@"integral_id",
             @"image":@"imagetitle"
             };
}

@end
