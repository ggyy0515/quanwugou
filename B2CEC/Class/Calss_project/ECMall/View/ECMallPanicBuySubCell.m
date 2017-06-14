//
//  ECMallPanicBuySubCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallPanicBuySubCell.h"
#import "ECMallPanicBuyProductModel.h"

@interface ECMallPanicBuySubCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *originPriceLabel;

@end

@implementation ECMallPanicBuySubCell

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
    [_imageView setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(175.f / 2.f);
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
    [self.contentView addSubview:_priceLabel];
    _priceLabel.font = FONT_28;
    _priceLabel.textColor = DarkColor;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView);
        make.height.mas_equalTo(14.f);
        make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom).offset(10.f);
        make.width.mas_equalTo(0.f);
    }];
    
    if (!_originPriceLabel) {
        _originPriceLabel = [UILabel new];
    }
    [self.contentView addSubview:_originPriceLabel];
    [_originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.priceLabel.mas_bottom);
        make.left.mas_equalTo(weakSelf.priceLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(11.f);
        make.width.mas_equalTo(0.f);
    }];
}

- (void)setModel:(ECMallPanicBuyProductModel *)model {
    WEAK_SELF
    
    _model = model;
    _contentLabel.text = model.proName;
    NSString *price = [NSString stringWithFormat:@"￥%@", model.price];
    _priceLabel.text = price;
    CGFloat priceWidth = ceilf([price boundingRectWithSize:CGSizeMake(10000, 14.f)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:FONT_28}
                                                   context:nil].size.width);
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView);
        make.height.mas_equalTo(14.f);
        make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom).offset(10.f);
        make.width.mas_equalTo(priceWidth);
    }];
    
    NSAttributedString *originPrice = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model.originPrice]
                                                                      attributes:@{NSFontAttributeName:FONT_22,
                                                                                   NSForegroundColorAttributeName:LightColor,
                                                                                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid)
                                                                                   }];
    _originPriceLabel.attributedText = originPrice;
    CGFloat originPriceWidth = ceilf([originPrice boundingRectWithSize:CGSizeMake(1000, 11.f)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                               context:nil].size.width);
    [_originPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.priceLabel.mas_bottom);
        make.left.mas_equalTo(weakSelf.priceLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(11.f);
        make.width.mas_equalTo(originPriceWidth);
    }];
    
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
