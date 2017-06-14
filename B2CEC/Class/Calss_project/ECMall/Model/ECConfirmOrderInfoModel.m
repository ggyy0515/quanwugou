//
//  ECConfirmOrderInfoModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECConfirmOrderInfoModel.h"

@implementation ECConfirmOrderInfoModel

+ (instancetype)modelWithTitle:(NSString *)title content:(NSString *)content {
    ECConfirmOrderInfoModel *model = [[self alloc] init];
    model.title = title;
    model.content = content;
    return model;
}

@end
