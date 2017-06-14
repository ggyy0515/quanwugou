//
//  ECProductGuaranteeSubCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductGuaranteeSubCell.h"

@interface ECProductGuaranteeSubCell ()

@property (nonatomic, strong) UIImageView *logo;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ECProductGuaranteeSubCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_logo) {
        _logo = [UIImageView new];
    }
    [self.contentView addSubview:_logo];
    [_logo setImage:[UIImage imageNamed:@"shop_icon_v"]];
    [_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18.f, 18.f));
        make.left.centerY.mas_equalTo(weakSelf.contentView);
    }];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_24;
    _titleLabel.textColor = LightMoreColor;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.logo.mas_right).offset(4.f);
        make.right.top.bottom.mas_equalTo(weakSelf.contentView);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
