//
//  ECOrderProductModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderProductModel.h"

@implementation ECOrderProductModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"amount" : @"amount",
             @"image" : @"imageTitle",
             @"orderId":@"orderids",
             @"price":@"price",
             @"name":@"proName",
             @"count":@"proQty",
             @"proId":@"proIds",
             @"protable":@"protable",
             @"leftpay":@"leftpay",
             @"orderDetailId":@"order_detail_id",
             @"nowPay":@"nowpay",
             @"isEasyPay":@"iseasypay"
             };
}

@end
