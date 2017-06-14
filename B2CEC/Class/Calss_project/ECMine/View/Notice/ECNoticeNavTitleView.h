//
//  ECNoticeNavTitleView.h
//  B2CEC
//
//  Created by Tristan on 2016/12/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECNoticeNavTitleView : UIView

@property (nonatomic, strong) UIView *chatRed;
@property (nonatomic, strong) UIView *noticeRed;

@property (nonatomic, copy) void(^clickChatBtn)();
@property (nonatomic, copy) void(^clickNoticeBtn)();

- (void)selectIndex:(NSInteger)Index;

- (instancetype)initWithFrame:(CGRect)frame left:(BOOL)showLeftRed right:(BOOL)showRightRed;

@end
