//
//  ECTeamModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTeamModel.h"

@implementation ECTeamModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"point":@"point",
             @"USER_ID":@"USER_ID",
             @"NAME":@"NAME",
             @"TITLE_IMG":@"TITLE_IMG"
             };
}

@end
