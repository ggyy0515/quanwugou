//
//  ECNewsCommentViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"

@interface ECNewsCommentViewController : CMBaseTableViewController
//是否评论
@property (assign,nonatomic) BOOL isEdit;
//资讯Id
@property (strong,nonatomic) NSString *informationId;

@property (copy,nonatomic) void (^sendCommentTextBlock)();

@end
