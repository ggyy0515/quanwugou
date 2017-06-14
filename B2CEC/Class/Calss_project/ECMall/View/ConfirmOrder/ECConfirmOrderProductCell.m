//
//  ECConfirmOrderProductCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECConfirmOrderProductCell.h"
#import "ECCartProductModel.h"
#import "ECPointProductListModel.h"

@interface ECConfirmOrderProductCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *easyPayBtn;
@property (nonatomic, strong) UILabel *leftPayLabel;

@end

@implementation ECConfirmOrderProductCell

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
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(64.f, 64.f));
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.textColor = LightMoreColor;
    _nameLabel.font = FONT_28;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.imageView.mas_top).offset(12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
    }];
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self.contentView addSubview:_priceLabel];
    
    if (!_leftPayLabel) {
        _leftPayLabel = [UILabel new];
    }
    [self.contentView addSubview:_leftPayLabel];
    _leftPayLabel.textColor = LightMoreColor;
    _leftPayLabel.font = FONT_24;
    
    if (!_easyPayBtn) {
        _easyPayBtn = [UIButton new];
    }
    [self.contentView addSubview:_easyPayBtn];
    _easyPayBtn.titleLabel.font = FONT_24;
    [_easyPayBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    [_easyPayBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_easyPayBtn setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
    [_easyPayBtn setTitle:@"分期支付" forState:UIControlStateNormal];
    CGFloat textWidth = ceilf([@"分期支付" boundingRectWithSize:CGSizeMake(1000, 40)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:FONT_24}
                                                    context:nil].size.width);
    [_easyPayBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -23.f, 0, 23.f)];
    [_easyPayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, textWidth + 3.f, 0, -textWidth - 3.f)];
    [_easyPayBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.model.useEasyPay = !weakSelf.model.useEasyPay;
        if (weakSelf.refreshPrice) {
            weakSelf.refreshPrice();
        }
    }];
    
}

- (void)setModel:(ECCartProductModel *)model {
    WEAK_SELF
    _model = model;
    
    if (model.isEasyPay.integerValue == 0) {
        _easyPayBtn.hidden = YES;
    } else {
        _easyPayBtn.hidden = NO;
    }
    _easyPayBtn.selected = model.useEasyPay;
    
    NSString *strca = IMAGEURL(_model.image);
    ECLog(@"%@", strca);
    
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(_model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    
    _nameLabel.text = model.name;
    
    NSMutableAttributedString *priceAttStr = [[NSMutableAttributedString alloc] initWithString:@"￥"
                                                                                    attributes:@{NSFontAttributeName:FONT_B_28,
                                                                                                 NSForegroundColorAttributeName:UIColorFromHexString(@"#1a191e")}];
    NSMutableString *leftPayStr = [NSMutableString stringWithString:@"尾款￥"];
    if (model.useQcode) {
        //使用Q码或会员价
        if (model.useEasyPay) {
            //使用分期
            [priceAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:model.nowVipPay
                                                                                attributes:@{NSFontAttributeName:FONT_B_28,
                                                                                             NSForegroundColorAttributeName:UIColorFromHexString(@"#1a191e")}]];
            [priceAttStr insertAttributedString:[[NSAttributedString alloc] initWithString:@"订金"
                                                                                attributes:@{NSFontAttributeName:FONT_24,
                                                                                             NSForegroundColorAttributeName:LightMoreColor}]
                                        atIndex:0];
        } else {
            //不使用分期
            [priceAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:model.vipPrice
                                                                                attributes:@{NSFontAttributeName:FONT_B_28,
                                                                                             NSForegroundColorAttributeName:UIColorFromHexString(@"#1a191e")}]];
        }
        //不论是否使用分期都给尾款赋值
        [leftPayStr appendString:model.leftVipPay];
    } else {
        //不使用Q码或非会员价
        if (model.useEasyPay) {
            //使用分期
            [priceAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:model.nowPay
                                                                                attributes:@{NSFontAttributeName:FONT_B_28,
                                                                                             NSForegroundColorAttributeName:UIColorFromHexString(@"#1a191e")}]];
            [priceAttStr insertAttributedString:[[NSAttributedString alloc] initWithString:@"订金"
                                                                                attributes:@{NSFontAttributeName:FONT_24,
                                                                                             NSForegroundColorAttributeName:LightMoreColor}]
                                        atIndex:0];
        } else {
            //不使用分期
            [priceAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:model.price
                                                                                attributes:@{NSFontAttributeName:FONT_B_28,
                                                                                             NSForegroundColorAttributeName:UIColorFromHexString(@"#1a191e")}]];
        }
        //不论是否使用分期都给尾款赋值
        [leftPayStr appendString:model.leftPay];
    }
    [leftPayStr appendFormat:@" *%@", model.count];
    [priceAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" *%@", model.count]
                                                                        attributes:@{NSFontAttributeName:FONT_24,
                                                                                     NSForegroundColorAttributeName:LightMoreColor}]];
    _priceLabel.attributedText = priceAttStr;
    CGFloat nowPriceWidth = ceilf([priceAttStr boundingRectWithSize:CGSizeMake(100000, 14.f)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil].size.width);
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(16.f);
        make.size.mas_equalTo(CGSizeMake(nowPriceWidth, 14.f));
    }];
    
    [_easyPayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.priceLabel.mas_bottom);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.size.mas_equalTo(CGSizeMake(75.f, 20.f));
    }];
    
    _leftPayLabel.hidden = !model.useEasyPay;
    _leftPayLabel.text = leftPayStr;
    CGFloat width = 0.f;
    if (model.useEasyPay) {
        width = [CMPublicMethod getWidthWithLabel:_leftPayLabel];
    }
    [_leftPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.priceLabel.mas_right).offset(16.f);
        make.bottom.mas_equalTo(weakSelf.priceLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.leftPayLabel.font.lineHeight);
        make.right.mas_equalTo(weakSelf.easyPayBtn.mas_left).offset(-12.f);
    }];
    
    
}

- (void)setPointModel:(ECPointProductListModel *)pointModel {
    WEAK_SELF
    
    _pointModel = pointModel;
    _easyPayBtn.hidden = YES;
    _leftPayLabel.hidden = YES;
    
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(pointModel.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    
    _nameLabel.text = pointModel.name;
    
    NSMutableAttributedString *pointStr = [[NSMutableAttributedString alloc] initWithString:pointModel.point
                                                                                 attributes:@{NSFontAttributeName:FONT_B_28,
                                                                                              NSForegroundColorAttributeName:UIColorFromHexString(@"#1a191e")}];
    [pointStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 积分"
                                                                     attributes:@{NSFontAttributeName:FONT_24,
                                                                                  NSForegroundColorAttributeName:LightMoreColor}]];
    _priceLabel.attributedText = pointStr;
    CGFloat width = ceilf([pointStr boundingRectWithSize:CGSizeMake(100000, 14.f)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                 context:nil].size.width);
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(16.f);
        make.size.mas_equalTo(CGSizeMake(width, 14.f));
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
