//
//  ECChatListModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECChatListModel.h"

@implementation ECChatListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"firendIds":@"USER_ID",
             @"headImage":@"TITLE_IMG",
             @"name":@"NAME"
             };
}

@end
