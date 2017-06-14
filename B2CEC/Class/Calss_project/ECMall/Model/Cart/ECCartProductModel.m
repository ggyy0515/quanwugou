//
//  ECCartProductModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCartProductModel.h"

@implementation ECCartProductModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"protable":@"protable",
             @"point":@"point",
             @"leftPay":@"leftpay",
             @"image":@"imgurl",
             @"price":@"price",
             @"proId":@"proid",
             @"nowPay":@"nowpay",
             @"stock":@"stock",
             @"isEasyPay":@"iseasypay",
             @"period":@"period",
             @"nowVipPay":@"nowvippay",
             @"name":@"proname",
             @"leftVipPay":@"leftvippay",
             @"vipPrice":@"vipprice",
             @"cartId" : @"ORD_CART_ID",
             @"count" : @"PROQTY"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _isSelectet = NO;
    _useQcode = NO;
    _useEasyPay = NO;
    return YES;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    ECCartProductModel *copy = [[[self class] allocWithZone:zone] init];
    copy.protable = [_protable copyWithZone:zone];
    copy.point = [_point copyWithZone:zone];
    copy.leftPay = [_leftPay copyWithZone:zone];
    copy.image = [_image copyWithZone:zone];
    copy.price = [_price copyWithZone:zone];
    copy.proId = [_proId copyWithZone:zone];
    copy.nowPay = [_nowPay copyWithZone:zone];
    copy.stock = [_stock copyWithZone:zone];
    copy.isEasyPay = [_isEasyPay copyWithZone:zone];
    copy.period = [_period copyWithZone:zone];
    copy.nowVipPay = [_nowVipPay copyWithZone:zone];
    copy.name = [_name copyWithZone:zone];
    copy.leftVipPay = [_leftPay copyWithZone:zone];
    copy.vipPrice = [_vipPrice copyWithZone:zone];
    copy.count = [_count copyWithZone:zone];
    copy.cartId = [_cartId copyWithZone:zone];
    copy.isSelectet = _isSelectet;
    copy.useQcode = _useQcode;
    copy.useEasyPay = _useEasyPay;
    return copy;
}



@end
