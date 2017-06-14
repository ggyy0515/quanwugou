//
//  ECNewsBigImageViewViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@interface ECNewsBigImageViewViewController : CMBaseViewController
//资讯编码
@property (strong,nonatomic) NSString *BIANMA;
//资讯Id
@property (strong,nonatomic) NSString *informationId;

@property (copy,nonatomic) void (^sendCommentTextBlock)();

@end
