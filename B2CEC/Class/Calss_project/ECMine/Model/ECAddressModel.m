//
//  ECAddressModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAddressModel.h"

@implementation ECAddressModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"address":@"address",
             @"area":@"area",
             @"userid":@"userid",
             @"consignee":@"consignee",
             @"is_default":@"is_default",
             @"mobile_no" : @"mobile_no",
             @"delivery_id":@"delivery_id"
             };
}

@end
