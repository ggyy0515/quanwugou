//
//  ECWalletPageActionCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWalletPageActionCell.h"

@interface ECWalletPageActionCell ()

@property (nonatomic, strong) UIButton *cashBtn;
@property (nonatomic, strong) UIButton *cardBtn;
@property (nonatomic, strong) UIView *line;

@end

@implementation ECWalletPageActionCell

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
        make.width.mas_equalTo(0.5);
    }];
    
    if (!_cardBtn) {
        _cashBtn = [UIButton new];
    }
    [self.contentView addSubview:_cashBtn];
    _cashBtn.titleLabel.font = FONT_32;
    [_cashBtn setTitle:@"提现" forState:UIControlStateNormal];
    [_cashBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    [_cashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(weakSelf.contentView);
        make.right.mas_equalTo(weakSelf.line.mas_left);
    }];
    [_cashBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickCashBtn) {
            weakSelf.clickCashBtn();
        }
    }];
    
    if (!_cardBtn) {
        _cardBtn = [UIButton new];
    }
    [self.contentView addSubview:_cardBtn];
    _cardBtn.titleLabel.font = FONT_32;
    [_cardBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    [_cardBtn setTitle:@"银行卡" forState:UIControlStateNormal];
    [_cardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(weakSelf.line.mas_right);
    }];
    [_cardBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickCardBtn) {
            weakSelf.clickCardBtn();
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
