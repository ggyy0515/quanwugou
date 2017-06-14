//
//  ECPaymentFooterView.m
//  B2CEC
//
//  Created by Tristan on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPaymentFooterView.h"

@interface ECPaymentFooterView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ECPaymentFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = BaseColor;
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self addSubview:_titleLabel];
    _titleLabel.textColor = LightColor;
    _titleLabel.font = FONT_24;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _titleLabel.text = @"温馨提示：选择上方一种付款方式即进入对应付款页面";
    
}

@end
