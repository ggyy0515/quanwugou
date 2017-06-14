//
//  ECUserInfoCommentModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/19.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoCommentModel.h"

@implementation ECUserInfoCommentModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"comment":@"comment",
             @"comment_id":@"comment_id",
             @"createdate":@"createdate",
             @"designer_id":@"designer_id",
             @"imgurls":@"imgurls",
             @"name":@"name",
             @"star_level":@"star_level",
             @"title_img":@"title_img",
             @"userid":@"userid"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"imgurls" : [NSString class]
             };
}

@end
