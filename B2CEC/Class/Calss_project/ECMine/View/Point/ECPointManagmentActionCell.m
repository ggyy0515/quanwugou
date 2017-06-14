//
//  ECPointManagmentActionCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointManagmentActionCell.h"

@interface ECPointManagmentActionCell ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation ECPointManagmentActionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = BaseColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo(1.f);
    }];
    
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
    }
    [self.contentView addSubview:_leftBtn];
    [_leftBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = FONT_32;
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(weakSelf.contentView);
        make.right.mas_equalTo(weakSelf.line.mas_left);
    }];
    [_leftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.leftBtnClick) {
            weakSelf.leftBtnClick();
        }
    }];
    
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
    }
    [self.contentView addSubview:_rightBtn];
    [_rightBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = FONT_32;
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.line.mas_right);
        make.top.bottom.right.mas_equalTo(weakSelf.contentView);
    }];
    [_rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.rightBtnClick) {
            weakSelf.rightBtnClick();
        }
    }];
    
    if ([[USERDEFAULT objectForKey:EC_USER_STATUS] isEqualToString:@"2"]) {
        [_leftBtn setTitle:@"积分兑现" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"积分分布" forState:UIControlStateNormal];
    } else {
        [_leftBtn setTitle:@"积分商城" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"兑换记录" forState:UIControlStateNormal];
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
