//
//  ECOrderCommentModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2017/1/18.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECOrderCommentModel : NSObject
//评论的商品图片
@property (nonatomic, copy) NSString *imageTitle;
//评论的ID
@property (nonatomic, copy) NSString *comment_id;
//评论的商品名称
@property (nonatomic, copy) NSString *proName;

@property (nonatomic, copy) NSArray *imgurls;
//评论时间
@property (nonatomic, copy) NSString *createdate;
//订单ID
@property (nonatomic, copy) NSString *orderid;
//评论内容
@property (nonatomic, copy) NSString *comment;

@property (nonatomic, copy) NSString *star_level;

@end
