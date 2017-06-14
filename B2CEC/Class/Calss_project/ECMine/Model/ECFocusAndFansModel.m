//
//  ECFocusAndFansModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECFocusAndFansModel.h"

@implementation ECFocusAndFansModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"ATTENTION_COUNT":@"ATTENTION_COUNT",
             @"FANS_COUNT":@"FANS_COUNT",
             @"fansID":@"ID",
             @"NAME":@"NAME",
             @"RIGHTS":@"RIGHTS",
             @"TITLE_IMG":@"TITLE_IMG",
             @"USER_ID_ONE":@"USER_ID_ONE",
             @"USER_ID_TWO":@"USER_ID_TWO",
             @"WORK_COUNT":@"WORK_COUNT",
             @"isAttention":@"isAttention"
             };
}

@end
