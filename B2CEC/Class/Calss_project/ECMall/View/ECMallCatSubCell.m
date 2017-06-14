//
//  ECMallCatSubCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallCatSubCell.h"
#import "ECMallFloorProductModel.h"

@interface ECMallCatSubCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation ECMallCatSubCell

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
    [_imageView setImage:[UIImage imageNamed:@"placeholder_goods2"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo((SCREENWIDTH - 32.f) / 3.f);
    }];
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    [self.contentView addSubview:_contentLabel];
    _contentLabel.textColor = LightColor;
    _contentLabel.font = FONT_24;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).offset(10.f);
        make.height.mas_equalTo(12.f);
    }];
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_priceLabel];
    _priceLabel.font = FONT_28;
    _priceLabel.textColor = DarkColor;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.imageView);
        make.height.mas_equalTo(14.f);
        make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom).offset(10.f);
    }];
    
}

- (void)setModel:(ECMallFloorProductModel *)model {
    _model = model;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
    _contentLabel.text = model.proName;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
