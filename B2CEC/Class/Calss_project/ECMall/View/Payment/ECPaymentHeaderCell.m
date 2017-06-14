//
//  ECPaymentHeaderCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPaymentHeaderCell.h"

@interface ECPaymentHeaderCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ECPaymentHeaderCell

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
    _titleLabel.textColor = LightColor;
    _titleLabel.font = FONT_32;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _titleLabel.text = @"选择付款方式";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
