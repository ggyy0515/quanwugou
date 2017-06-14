//
//  ECBrandStoryInfoModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECBrandStoryInfoModel.h"

@implementation ECBrandStoryInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"content" : @"content",
             @"slogan" : @"slogan",
             @"name" : @"name",
             @"image" : @"appimg",
             @"telephone" : @"telephone"
             };
}

@end
