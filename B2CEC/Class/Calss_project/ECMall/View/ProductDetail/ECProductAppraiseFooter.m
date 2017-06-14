//
//  ECProductAppraiseFooter.m
//  B2CEC
//
//  Created by Tristan on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAppraiseFooter.h"

@interface ECProductAppraiseFooter ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation ECProductAppraiseFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self addSubview:_line];
    _line.backgroundColor = BaseColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self addSubview:_titleLabel];
    _titleLabel.font = FONT_28;
    _titleLabel.textColor = DarkColor;
    _titleLabel.text = @"点击查看更多";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf.titleLabel.font.lineHeight);
    }];
    
    [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (weakSelf.moreAppraiseAction) {
            weakSelf.moreAppraiseAction();
        }
    }];
}

@end
