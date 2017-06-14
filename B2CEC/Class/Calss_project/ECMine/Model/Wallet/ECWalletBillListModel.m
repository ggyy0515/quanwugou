//
//  ECWalletBillListModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWalletBillListModel.h"

@implementation ECWalletBillListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"amount":@"amount",
             @"type":@"type",
             @"ids":@"ids",
             @"createDate":@"createdateStr",
             @"detail":@"detail",
             @"symbolAmount":@"symbolamount",
             @"image":@"imgurl"
             };
}

@end
