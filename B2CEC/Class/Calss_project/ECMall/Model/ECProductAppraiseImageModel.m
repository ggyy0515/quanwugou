//
//  ECProductAppraiseImageModel.m
//  B2CEC
//
//  Created by Tristan on 2016/11/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAppraiseImageModel.h"

@implementation ECProductAppraiseImageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"image" : @"url"
             };
}

@end
