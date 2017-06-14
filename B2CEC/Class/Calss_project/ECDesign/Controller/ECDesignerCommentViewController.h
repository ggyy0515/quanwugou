//
//  ECDesignerCommentViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"

@interface ECDesignerCommentViewController : CMBaseTableViewController
//是否评论
@property (assign,nonatomic) BOOL isEdit;

@property (strong,nonatomic) NSString *worksID;

@property (copy,nonatomic) void (^sendCommentTextBlock)();

@end
