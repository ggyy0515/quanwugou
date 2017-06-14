//
//  ECProductAppraiseHeader.m
//  B2CEC
//
//  Created by Tristan on 2016/11/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAppraiseHeader.h"

@interface ECProductAppraiseHeader ()

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 箭头
 */
@property (nonatomic, strong) UIImageView *arrow;
/**
 评论数
 */
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation ECProductAppraiseHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_arrow) {
        _arrow = [UIImageView new];
    }
    [self addSubview:_arrow];
    [_arrow setImage:[UIImage imageNamed:@"icon_more"]];
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
        make.right.mas_equalTo(weakSelf.mas_right).offset(-12.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self addSubview:_titleLabel];
    _titleLabel.font = FONT_28;
    _titleLabel.textColor = LightMoreColor;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(80.f, 14.f));
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    
    if (!_countLabel) {
        _countLabel = [UILabel new];
    }
    [self addSubview:_countLabel];
    _countLabel.font = FONT_28;
    _countLabel.textColor = LightMoreColor;
    _countLabel.textAlignment = NSTextAlignmentRight;
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf);
        make.right.mas_equalTo(weakSelf.arrow.mas_left).offset(-8.f);
        make.left.mas_equalTo(weakSelf.titleLabel.mas_right);
    }];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self addSubview:_line];
    _line.backgroundColor = BaseColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.bottom.mas_equalTo(weakSelf);
    }];
}

- (void)setAppraiseCount:(NSString *)appraiseCount {
    _appraiseCount = appraiseCount;
    _countLabel.text = [NSString stringWithFormat:@"%@人评论", appraiseCount];
}

@end
