//
//  ECBankListCardModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECBankCardListModel.h"

@implementation ECBankCardListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"bankId":@"bankid",
             @"bankNo":@"bankno",
             @"image":@"imagetitle",
             @"bankName":@"bankname",
             @"isDefault":@"isdefault"
             };
}

@end
