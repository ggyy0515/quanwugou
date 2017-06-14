//
//  ECWalletInfoModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWalletInfoModel.h"

@implementation ECWalletInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"balance":@"balance",
             @"hasChange":@"haschange",
             @"ids":@"ids"
             };
}

@end
