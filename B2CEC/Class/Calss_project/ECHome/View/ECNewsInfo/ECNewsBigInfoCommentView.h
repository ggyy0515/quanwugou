//
//  ECNewsBigInfoCommentView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECNewsBigInfoCommentView : UIView

@property (assign,nonatomic) BOOL isBecomeInput;

@property (copy,nonatomic) void (^sendCommentTextBlock)(NSString *comment);

@end
