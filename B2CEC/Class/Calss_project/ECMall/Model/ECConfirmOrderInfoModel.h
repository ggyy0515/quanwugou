//
//  ECConfirmOrderInfoModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECConfirmOrderInfoModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

+ (instancetype)modelWithTitle:(NSString *)title content:(NSString *)content;

@end
