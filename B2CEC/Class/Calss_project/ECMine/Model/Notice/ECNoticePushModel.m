//
//  ECNoticePushModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNoticePushModel.h"

@implementation ECNoticePushModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"content":@"content",
             @"addtime":@"addtime",
             @"title":@"title"
             };
}

@end
