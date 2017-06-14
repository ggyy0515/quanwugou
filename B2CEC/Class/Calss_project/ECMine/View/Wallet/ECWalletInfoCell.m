//
//  ECWalletInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWalletInfoCell.h"
#import "ECWalletInfoModel.h"

@interface ECWalletInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *balanceLabel;

@end

@implementation ECWalletInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = MainColor;
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_32;
    _titleLabel.textColor = UIColorFromHexString(@"#A8A8A9");
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(94.f / 2.f);
        make.height.mas_equalTo(16.f);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
    }];
    
    if (!_balanceLabel) {
        _balanceLabel = [UILabel new];
    }
    [self.contentView addSubview:_balanceLabel];
    _balanceLabel.textColor = UIColorFromHexString(@"#ffffff");
    [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(64.f);
        make.left.right.mas_equalTo(weakSelf.titleLabel);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(76.f / 2.f);
    }];
}

- (void)setModel:(ECWalletInfoModel *)model {
    _model = model;
    _titleLabel.text = @"账户余额（元）";
    if (model.balance.floatValue >= 100000) {
        _balanceLabel.font = [UIFont systemFontOfSize:52.f];
    } else {
        _balanceLabel.font = [UIFont systemFontOfSize:64.f];
    }
    _balanceLabel.text = model.balance;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
