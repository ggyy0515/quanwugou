//
//  ECCommitOrderInfoModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCommitOrderInfoModel.h"

@implementation ECCommitOrderInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"orderNumbers" : @"ordernos",
             @"totalPrice" : @"totalAmount",
             @"leftPay":@"totalLeftPay",
             @"nowPay":@"totalNowPay"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"orderNumbers" : [NSString class]
             };
}

@end
