//
//  ECMallNavTagViewCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallNavTagViewCell.h"

@interface ECMallNavTagViewCell ()



@end

@implementation ECMallNavTagViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_28;
    _titleLabel.textColor = LightMoreColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    if (!_line) {
        _line = [UILabel new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = MainColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(32.f);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
    }];
    _line.hidden = YES;
}

- (void)setTitle:(NSString *)title {
    WEAK_SELF
    _title = title;
    
    _titleLabel.text = title;
    CGFloat width = [title boundingRectWithSize:CGSizeMake(10000, 14.f)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]}
                                        context:nil].size.width;
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(width);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
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
