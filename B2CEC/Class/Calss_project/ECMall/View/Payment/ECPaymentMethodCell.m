//
//  ECPaymentMethodCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPaymentMethodCell.h"

@interface ECPaymentMethodCell ()

@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation ECPaymentMethodCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20.f);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_32;
    _titleLabel.textColor = DarkMoreColor;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, weakSelf.titleLabel.font.lineHeight));
    }];
    
    
    if (!_arrow) {
        _arrow = [UIImageView new];
    }
    [self.contentView addSubview:_arrow];
    [_arrow setImage:[UIImage imageNamed:@"icon_more"]];
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
        make.right.mas_equalTo(weakSelf.mas_right).offset(-20.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font = FONT_32;
    _contentLabel.textColor = LightMoreColor;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(weakSelf.titleLabel.mas_right);
        make.right.mas_equalTo(weakSelf.arrow.mas_left).offset(-12.f);
        make.height.mas_equalTo(weakSelf.contentLabel.font.lineHeight);
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
