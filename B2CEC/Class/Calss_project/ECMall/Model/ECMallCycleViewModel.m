//
//  ECMallCycleViewModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallCycleViewModel.h"

@implementation ECMallCycleViewModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"image" : @"app_imgurl",
             @"webUrl" : @"weburl",
             @"title":@"title"
             };
}


@end
