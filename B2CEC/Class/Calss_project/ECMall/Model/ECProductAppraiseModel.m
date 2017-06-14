//
//  ECProductAppraiseModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAppraiseModel.h"
#import "ECProductAppraiseImageModel.h"

@implementation ECProductAppraiseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"headImage" : @"title_img",
             @"name" : @"name",
             @"appraiseTime" : @"createdate",
             @"userId" : @"userid",
             @"buyTime" : @"buyDate",
             @"content" : @"comment",
             @"score" : @"star_level",
             @"imageList" : @"commentImg"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"imageList" : [ECProductAppraiseImageModel class]
             };
}




@end
