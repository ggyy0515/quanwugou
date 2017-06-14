//
//  ECNoticeNavTitleView.m
//  B2CEC
//
//  Created by Tristan on 2016/12/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNoticeNavTitleView.h"

@interface ECNoticeNavTitleView ()

@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UIButton *noticeBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL showLeftRed;
@property (nonatomic, assign) BOOL showRightRed;

@end

@implementation ECNoticeNavTitleView

- (instancetype)initWithFrame:(CGRect)frame left:(BOOL)showLeftRed right:(BOOL)showRightRed {
    if (self = [super initWithFrame:frame]) {
        _showLeftRed = showLeftRed;
        _showRightRed = showRightRed;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = ClearColor;
    
    if (!_chatBtn) {
        _chatBtn = [UIButton new];
    }
    [self addSubview:_chatBtn];
    [_chatBtn setTitle:@"聊天" forState:UIControlStateNormal];
    [_chatBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _chatBtn.titleLabel.font = FONT_36;
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(weakSelf);
        make.width.mas_equalTo(80.f);
    }];
    [_chatBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickChatBtn) {
            weakSelf.clickChatBtn();
        }
    }];
    
    if (!_chatRed) {
        _chatRed = [UIView new];
    }
    [self addSubview:_chatRed];
    _chatRed.backgroundColor = UIColorFromHexString(@"#EB3A41");
    _chatRed.layer.cornerRadius = 4.f;
    _chatRed.layer.masksToBounds = YES;
    _chatRed.hidden = !_showLeftRed;
    [_chatRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.chatBtn.mas_right).offset(-22.f);
        make.top.mas_equalTo(weakSelf.chatBtn.mas_top).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(8.f, 8.f));
    }];
    
    if (!_noticeBtn) {
        _noticeBtn = [UIButton new];
    }
    [self addSubview:_noticeBtn];
    [_noticeBtn setTitle:@"通知" forState:UIControlStateNormal];
    [_noticeBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _noticeBtn.titleLabel.font = FONT_36;
    [_noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(80.f);
    }];
    [_noticeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickNoticeBtn) {
            weakSelf.clickNoticeBtn();
        }
    }];
    
    if (!_noticeRed) {
        _noticeRed = [UIView new];
    }
    [self addSubview:_noticeRed];
    _noticeRed.backgroundColor = UIColorFromHexString(@"#EB3A41");
    _noticeRed.layer.cornerRadius = 4.f;
    _noticeRed.layer.masksToBounds = YES;
    _noticeRed.hidden = !_showRightRed;
    [_noticeRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.noticeBtn.mas_right).offset(-22.f);
        make.top.mas_equalTo(weakSelf.noticeBtn.mas_top).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(8.f, 8.f));
    }];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self addSubview:_line];
    _line.backgroundColor = MainColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35.f, 2.f));
        make.centerX.bottom.mas_equalTo(weakSelf.chatBtn);
    }];
}

- (void)selectIndex:(NSInteger)Index {
    WEAK_SELF
    if (Index == 0) {
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35.f, 2.f));
            make.centerX.bottom.mas_equalTo(weakSelf.chatBtn);
        }];
    } else {
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35.f, 2.f));
            make.centerX.bottom.mas_equalTo(weakSelf.noticeBtn);
        }];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
