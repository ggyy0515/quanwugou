//
//  ECNewsCommentModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsCommentModel.h"
#import "ECHomeNewsListModel.h"

@implementation ECNewsRecommendModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"classify" : @"classify",
             @"newsID" : @"id",
             @"title" : @"title",
             @"type" : @"type",
             @"resource" : @"resource"
             };
}

@end

@implementation ECNewsInfomationModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"Boo" : @"Boo",
             @"commentNum" : @"commentNum",
             @"content" : @"content",
             @"createdate" : @"createdate",
             @"newsid" : @"id",
             @"iscollect" : @"iscollect",
             @"isoriginal" : @"isoriginal",
             @"praise" : @"praise",
             @"praiseType" : @"praiseType",
             @"resource" : @"resource",
             @"title" : @"title",
             @"type" : @"type",
             @"videolength" : @"videolength",
             @"viewNumber" : @"viewNumber",
             @"videoUrl" : @"videoUrl",
             @"getContentUrl" : @"getContentUrl",
             @"isattention" : @"isattention",
             @"imageList" : @"imageList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"imageList" : [ECHomeNewsImageListModel class]
             };
}

@end

@implementation ECNewsCommentModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"information_id" : @"information_id",
             @"content" : @"content",
             @"commentID" : @"id",
             @"user_id" : @"user_id",
             @"edittime" : @"edittime",
             @"title_img" : @"title_img",
             @"name":@"name"
             };
}

@end
