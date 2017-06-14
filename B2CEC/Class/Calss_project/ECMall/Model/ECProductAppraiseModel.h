//
//  ECProductAppraiseModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECProductAppraiseImageModel;

@interface ECProductAppraiseModel : NSObject

/**
 用户头像
 */
@property (nonatomic, copy) NSString *headImage;
/**
 用户名
 */
@property (nonatomic, copy) NSString *name;
/**
 评论时间
 */
@property (nonatomic, copy) NSString *appraiseTime;
/**
 用户id
 */
@property (nonatomic, copy) NSString *userId;
/**
 购买时间
 */
@property (nonatomic, copy) NSString *buyTime;
/**
 评论内容
 */
@property (nonatomic, copy) NSString *content;
/**
 得分
 */
@property (nonatomic, copy) NSString *score;
/**
 评论图片
 */
@property (nonatomic, strong) NSArray <ECProductAppraiseImageModel *> *imageList;

@end
