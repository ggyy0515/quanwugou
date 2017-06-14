//
//  ECOrderCommentModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2017/1/18.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "ECOrderCommentModel.h"

@implementation ECOrderCommentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"imageTitle" : @"imageTitle",
             @"comment_id" : @"comment_id",
             @"proName":@"proName",
             @"imgurls":@"imgurls",
             @"createdate":@"createdate",
             @"orderid":@"orderid",
             @"comment":@"comment",
             @"star_level":@"star_level"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"imgurls" : [NSString class]
             };
}

@end
