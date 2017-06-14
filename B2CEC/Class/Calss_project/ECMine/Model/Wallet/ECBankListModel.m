//
//  ECBankListModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECBankListModel.h"

@implementation ECBankListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"ids":@"DICTIONARIES_ID",
             @"code":@"BIANMA",
             @"name":@"NAME",
             @"image":@"ICON"
             };
}


@end
