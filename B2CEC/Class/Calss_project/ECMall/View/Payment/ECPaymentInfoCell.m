//
//  ECPaymentInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPaymentInfoCell.h"
#import "ECCommitOrderInfoModel.h"

@interface ECPaymentInfoCell ()

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *orderNumLabel;

@end

@implementation ECPaymentInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = MainColor;
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self.contentView addSubview:_priceLabel];
    _priceLabel.font = [UIFont systemFontOfSize:40.f];
    _priceLabel.textColor = UIColorFromHexString(@"#ffffff");
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY).offset(-15.f);
        make.height.mas_equalTo(weakSelf.priceLabel.font.lineHeight);
    }];
    
    if (!_orderNumLabel) {
        _orderNumLabel = [UILabel new];
    }
    [self.contentView addSubview:_orderNumLabel];
    _orderNumLabel.textColor = UIColorFromHexString(@"#ffffff");
    _orderNumLabel.font = FONT_28;
    _orderNumLabel.textAlignment = NSTextAlignmentCenter;
    [_orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.priceLabel.mas_bottom).offset(12.f);
        make.height.mas_equalTo(weakSelf.orderNumLabel.font.lineHeight);
    }];
    _orderNumLabel.hidden = YES;
}

- (void)setModel:(ECCommitOrderInfoModel *)model {
    _model = model;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.nowPay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
