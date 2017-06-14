//
//  ECDesignerModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerModel.h"

@implementation ECDesignerOrderDetailModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"batchNo":@"batchNo",
             @"claim":@"claim",
             @"createdate":@"createdate",
             @"cycle":@"cycle",
             @"decoratetype":@"decoratetype",
             @"describe" : @"describe",
             @"designer_id":@"designer_id",
             @"designer_user_id":@"designer_user_id",
             @"dname":@"dname",
             @"dtitle_img":@"dtitle_img",
             @"housearea":@"housearea",
             @"housetype":@"housetype",
             @"orderid":@"id",
             @"lat":@"lat",
             @"lng" : @"lng",
             @"location":@"location",
             @"money":@"money",
             @"paymode":@"paymode",
             @"state":@"state",
             @"style":@"style",
             @"tranNo":@"tranNo",
             @"uname":@"uname",
             @"updatedate" : @"updatedate",
             @"user_id":@"user_id",
             @"utitle_img":@"utitle_img",
             @"imgurls":@"imgurls"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"coverList" : [NSString class]
             };
}

@end

@implementation ECDesignerModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"ATTENTION":@"ATTENTION",
             @"ATTENTION_COUNT":@"ATTENTION_COUNT",
             @"FANS_COUNT":@"FANS_COUNT",
             @"NAME":@"NAME",
             @"TITLE_IMG":@"TITLE_IMG",
             @"USERINFO_ID" : @"USERINFO_ID",
             @"USER_ID":@"USER_ID",
             @"WORK_COUNT":@"WORK_COUNT",
             @"coverList":@"coverList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"coverList" : [NSString class]
             };
}

@end
