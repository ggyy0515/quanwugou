//
//  ECMineModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMineModel.h"

@implementation ECMineUserModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"NAME":@"NAME",
             @"RIGHTS":@"RIGHTS",
             @"USERSTATE":@"USERSTATE",
             @"TITLE_IMG":@"TITLE_IMG"
             };
}

@end

@implementation ECMineModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"ATTENTION_COUNT":@"ATTENTION_COUNT",
             @"FANS_COUNT":@"FANS_COUNT",
             @"INTEGRATE":@"INTEGRATE",
             @"MONEY":@"MONEY",
             @"RETURNOREXCHANGE":@"RETURNOREXCHANGE",
             @"WAITCOMMENT":@"WAITCOMMENT",
             @"WAITGETGOODS":@"WAITGETGOODS",
             @"WAITPAY" : @"WAITPAY",
             @"WAITSENDGOODS":@"WAITSENDGOODS",
             @"WORK_COUNT":@"WORK_COUNT",
             @"ISEXISTUNREAD":@"ISEXISTUNREAD",
             @"ISEXISTUNDEAL":@"ISEXISTUNDEAL",
             @"user":@"user"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"user" : [ECMineUserModel class]
             };
}

@end
