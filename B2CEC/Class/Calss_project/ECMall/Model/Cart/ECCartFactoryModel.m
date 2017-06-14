//
//  ECCartFactoryModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCartFactoryModel.h"
#import "ECCartProductModel.h"

@implementation ECCartFactoryModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"seller" : @"seller",
             @"productCount" : @"amount",
             @"productList":@"product",
             @"sellerId":@"seller_id"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"productList" : [ECCartProductModel class]
             };
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    ECCartFactoryModel *copy = [[[self class] allocWithZone:zone] init];
    copy.seller = [_seller copyWithZone:zone];
    copy.productCount = [_productCount copyWithZone:zone];
    copy.productList = [_productList mutableCopyWithZone:zone];
    copy.sellerId = [_sellerId copyWithZone:zone];
    copy.message = [_message copyWithZone:zone];
    return copy;
}

@end
