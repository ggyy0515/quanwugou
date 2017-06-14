//
//  ECWorksModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWorksModel.h"

@implementation ECWorksCommentModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"content":@"content",
             @"commentID":@"id",
             @"edittime":@"edittime",
             @"title_img":@"title_img",
             @"case_id":@"case_id",
             @"user_id":@"user_id",
             @"name":@"name"
             };
}

@end

@implementation ECLogsModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"logsID":@"id",
             @"title":@"title",
             @"createdate":@"createdate",
             @"user_id":@"user_id",
             @"imgurl":@"imgurl"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"imgurl" : [NSString class]
             };
}

@end

@implementation ECWorksDetailUserModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"ATTENTION":@"ATTENTION",
             @"ATTENTION_COUNT":@"ATTENTION_COUNT",
             @"FANS_COUNT":@"FANS_COUNT",
             @"NAME":@"NAME",
             @"TITLE_IMG":@"TITLE_IMG",
             @"USERINFO_ID":@"USERINFO_ID",
             @"USER_ID":@"USER_ID",
             @"WORK_COUNT":@"WORK_COUNT"
             };
}

@end

@implementation ECWorksDetailModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"Boo":@"Boo",
             @"collect":@"collect",
             @"comment":@"comment",
             @"content":@"content",
             @"cover":@"cover",
             @"createdate":@"createdate",
             @"housetype":@"housetype",
             @"workdID":@"id",
             @"istop":@"istop",
             @"praise":@"praise",
             @"praiseType":@"praiseType",
             @"style":@"style",
             @"title":@"title",
             @"type":@"type",
             @"iscollect":@"iscollect",
             @"updatedate":@"updatedate",
             @"user":@"user",
             @"user_id":@"user_id"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"user" : [ECWorksDetailUserModel class]
             };
}

@end

@implementation ECWorksModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"collect":@"collect",
             @"NAME":@"NAME",
             @"RIGHTS":@"RIGHTS",
             @"TITLE_IMG":@"TITLE_IMG",
             @"cover":@"cover",
             @"worksID":@"id",
             @"praise":@"praise",
             @"title":@"title",
             @"collect_id":@"collect_id",
             @"user_id":@"user_id"
             };
}

@end
