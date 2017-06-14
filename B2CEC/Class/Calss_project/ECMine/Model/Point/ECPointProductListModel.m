//
//  ECPointProductListModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointProductListModel.h"

@implementation ECPointProductListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"proId":@"id",
             @"image":@"imgurl",
             @"name":@"proname",
             @"point":@"integral"
             };
}


@end
