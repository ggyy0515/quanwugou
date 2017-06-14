//
//  ECNewsInputCommentView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECNewsInputCommentView : UIView

@property (strong,nonatomic) NSString *commentCount;

@property (strong,nonatomic) NSString *isCollect;

@property (assign,nonatomic) BOOL isInput;

@property (assign,nonatomic) BOOL isStyleBlack;

@property (copy,nonatomic) void (^inputClickBlock)();

@property (copy,nonatomic) void (^commentClickBlock)();

@property (copy,nonatomic) void (^collecClickBlock)();

@property (copy,nonatomic) void (^shareClickBlock)();

@property (copy,nonatomic) void (^sendCommentTextBlock)(NSString *comment);

@end
