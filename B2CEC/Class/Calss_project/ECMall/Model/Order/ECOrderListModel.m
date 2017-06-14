//
//  ECOrderListModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderListModel.h"
#import "ECOrderProductModel.h"

@implementation ECOrderListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"receiver" : @"receiver",
             @"tranNo" : @"tranNo",
             @"state":@"state",
             @"orderId":@"order_id",
             @"express":@"express",
             @"nowPay":@"nowpay",
             @"city":@"city",
             @"batchNo":@"batchNo",
             @"expressCode":@"expresscode",
             @"province":@"province",
             @"totalMoney":@"totalAmount",
             @"isDel":@"isdel",
             @"userId":@"user_id",
             @"createTime":@"createDate",
             @"updateBy":@"updateBy",
             @"payWay":@"paymode",
             @"iswxjspay":@"iswxjspay",
             @"updateTime":@"updateDate",
             @"message":@"message",
             @"subState":@"substate",
             @"qCode":@"discode",
             @"orderNo":@"orderNo",
             @"address":@"address",
             @"leftPay":@"leftpay",
             @"productList":@"orderDetailList",
             @"sellerId":@"seller_id",
             @"billTitle":@"invoicetitle",
             @"expressNumber":@"expressnumber",
             @"payTime":@"paytime_end",
             @"mobile":@"mobile",
             @"canReturn":@"iscanReturn",
             @"disCountMoney":@"discountmoney"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"productList" : [ECOrderProductModel class]
             };
}

@end
