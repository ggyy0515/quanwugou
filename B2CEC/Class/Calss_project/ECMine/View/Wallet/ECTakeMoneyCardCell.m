//
//  ECTakeMoneyCardCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTakeMoneyCardCell.h"
#import "ECBankCardListModel.h"

@interface ECTakeMoneyCardCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation ECTakeMoneyCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_32;
    _titleLabel.textColor = LightMoreColor;
    _titleLabel.text = @"银行卡";
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo(70.f);
    }];
    
    if (!_arrow) {
        _arrow = [UIImageView new];
    }
    [self.contentView addSubview:_arrow];
    [_arrow setImage:[UIImage imageNamed:@"enter"]];
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8.f, 15.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.right.mas_equalTo(-12.f);
    }];
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font = FONT_32;
    _contentLabel.textColor = DarkMoreColor;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.text = @"请选择银行卡";
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.arrow.mas_left).offset(-12.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(weakSelf.titleLabel.mas_right).offset(12.f);
    }];
}

- (void)setModel:(ECBankCardListModel *)model {
    _model = model;
    _contentLabel.text = model.bankName;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
