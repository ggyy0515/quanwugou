//
//  ECPointManagmentBillHeader.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointManagmentBillHeader.h"

@implementation ECPointManagmentBillHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        WEAK_SELF
        if (!_titleLabel) {
            _titleLabel = [UILabel new];
        }
        [self addSubview:_titleLabel];
        _titleLabel.font = FONT_28;
        _titleLabel.textColor = DarkMoreColor;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.f);
            make.right.mas_equalTo(-12.f);
            make.top.bottom.mas_equalTo(weakSelf);
        }];
    }
    return self;
}

@end
