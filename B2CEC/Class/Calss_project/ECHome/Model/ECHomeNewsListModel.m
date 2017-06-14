//
//  ECHomeNewsListModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeNewsListModel.h"

@implementation ECHomeNewsImageListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"image":@"image",
             @"orderby":@"orderby",
             @"title":@"title"
             };
}

@end

@implementation ECHomeNewsListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"classify" : @"classify",
             @"commentNum" : @"commentNum",
             @"cover1" : @"cover1",
             @"cover2":@"cover2",
             @"cover3":@"cover3",
             @"createdate":@"createdate",
             @"newsID":@"id",
             @"inforType":@"inforType",
             @"isoriginal":@"isoriginal",
             @"resource":@"resource",
             @"title":@"title",
             @"type":@"type",
             @"videolength":@"videolength",
             @"viewNumber":@"viewNumber",
             @"weburl":@"weburl",
             @"iscollect" : @"iscollect",
             @"isView" : @"isView",
             @"collect_id" : @"collect_id",
             @"imageList":@"imageList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"imageList" : [ECHomeNewsImageListModel class]
             };
}

@end
