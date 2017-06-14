//
//  ECProductInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductInfoCell.h"
#import "ECProductInfoModel.h"

@interface ECProductInfoCell ()

/**
 价格
 */
@property (nonatomic, strong) UILabel *priceLabel;
/**
 vipLogo
 */
@property (nonatomic, strong) UIImageView *vipLogo;
/**
 积分
 */
@property (nonatomic, strong) UILabel *pointLabel;
/**
 生产周期
 */
@property (nonatomic, strong) UILabel *produceTimeLabel;
/**
 商品名
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 产地
 */
@property (nonatomic, strong) UILabel *produceAreaLabel;
/**
 分割线
 */
@property (nonatomic, strong) UIView *line;

@end

@implementation ECProductInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self.contentView addSubview:_priceLabel];
    _priceLabel.textColor = UIColorFromHexString(@"#ee383b");
    _priceLabel.font = [UIFont systemFontOfSize:26.f];
    
    if (!_vipLogo) {
        _vipLogo = [UIImageView new];
    }
    _vipLogo.hidden = YES;
    [self.contentView addSubview:_vipLogo];
    [_vipLogo setImage:[UIImage imageNamed:@"VIP"]];
    
    if (!_pointLabel) {
        _pointLabel = [UILabel new];
    }
    [self.contentView addSubview:_pointLabel];
    _pointLabel.font = FONT_26;
    _pointLabel.textColor = LightMoreColor;
    
    if (!_produceTimeLabel) {
        _produceTimeLabel = [UILabel new];
    }
    [self.contentView addSubview:_produceTimeLabel];
    _produceTimeLabel.font = FONT_26;
    _produceTimeLabel.textColor = LightMoreColor;
    _produceTimeLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = UIColorFromHexString(@"#222222");
    
    if (!_produceAreaLabel) {
        _produceAreaLabel = [UILabel new];
    }
    [self.contentView addSubview:_produceAreaLabel];
    _produceAreaLabel.font = FONT_26;
    _produceAreaLabel.textColor = LightMoreColor;
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = BaseColor;
    
}

- (void)setModel:(ECProductInfoModel *)model {
    WEAK_SELF
    
    _model = model;
    NSString *price = [NSString stringWithFormat:@"￥%@", model.price];
    _priceLabel.text = price;
    CGFloat width = [CMPublicMethod getWidthWithLabel:_priceLabel];
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20.f);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(weakSelf.priceLabel.font.lineHeight);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(40.f);
    }];
    
    CGFloat vipWidth = 0;
    if (model.isDiscount.integerValue == 0) {
        vipWidth = 22.f;
        _vipLogo.hidden = NO;
    } else {
        vipWidth = 0;
        _vipLogo.hidden = YES;
    }
    [_vipLogo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.priceLabel.mas_right).offset(18.f);
        make.bottom.mas_equalTo(weakSelf.priceLabel);
        make.size.mas_equalTo(CGSizeMake(vipWidth, 14.f));
    }];
    
    NSString *point = [NSString stringWithFormat:@"积分%@", model.point];
    _pointLabel.text = point;
    width = [CMPublicMethod getWidthWithLabel:_pointLabel];
    [_pointLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.priceLabel);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.priceLabel.font.lineHeight));
        make.left.mas_equalTo(weakSelf.vipLogo.mas_right).offset(5.f);
    }];
    
    NSString *produceTime = [NSString stringWithFormat:@"生产周期：%@天", model.period];
    _produceTimeLabel.text = produceTime;
    width = [CMPublicMethod getWidthWithLabel:_produceTimeLabel];
    [_produceTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20.f);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.produceTimeLabel.font.lineHeight));
        make.bottom.mas_equalTo(weakSelf.priceLabel.mas_bottom);
    }];
    
    _nameLabel.text = model.name;
    CGFloat nameHeight = _nameLabel.font.lineHeight;
    width = [CMPublicMethod getWidthWithLabel:_nameLabel];
    if (width > (SCREENWIDTH - 150.f)) {
        width = (SCREENWIDTH - 150.f);
        _nameLabel.numberOfLines = 2;
        nameHeight = nameHeight * 2 + 5;
    }
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.priceLabel.mas_bottom).offset(14.f);
        make.left.mas_equalTo(weakSelf.priceLabel);
        make.size.mas_equalTo(CGSizeMake(width, nameHeight));
    }];
    
    NSString *area = [NSString stringWithFormat:@"产地：%@", model.area];
    _produceAreaLabel.text = area;
    width = [CMPublicMethod getWidthWithLabel:_produceAreaLabel];
    [_produceAreaLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.produceTimeLabel);
        make.bottom.mas_equalTo(weakSelf.nameLabel);
        make.size.mas_equalTo(CGSizeMake(width, _produceAreaLabel.font.lineHeight));
    }];
    
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH - 40.f, 1.f));
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
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
