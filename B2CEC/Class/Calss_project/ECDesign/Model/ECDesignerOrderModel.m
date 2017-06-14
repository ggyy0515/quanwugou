//
//  ECDesignerOrderModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderModel.h"

@implementation ECDesignerOrderModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"batchNo":@"batchNo",
             @"claim":@"claim",
             @"createdate":@"createdate",
             @"cycle":@"cycle",
             @"decoratetype":@"decoratetype",
             @"describe" : @"describe",
             @"designer_id":@"designer_id",
             @"dname":@"dname",
             @"dtitle_img" : @"dtitle_img",
             @"housearea":@"housearea",
             @"housetype":@"housetype",
             @"orderID" : @"id",
             @"imgurls":@"imgurls",
             @"lat":@"lat",
             @"lng" : @"lng",
             @"location":@"location",
             @"money":@"money",
             @"paymode" : @"paymode",
             @"state":@"state",
             @"style":@"style",
             @"tranNo":@"tranNo",
             @"uname":@"uname",
             @"user_id":@"user_id",
             @"utitle_img":@"utitle_img",
             @"updatedate":@"updatedate"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"imgurls" : [NSString class]
             };
}

@end
