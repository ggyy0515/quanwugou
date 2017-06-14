//
//  ECConfirmOrderFactoryHeader.m
//  B2CEC
//
//  Created by Tristan on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECConfirmOrderFactoryHeader.h"
#import "ECCartFactoryModel.h"
#import "ECCartProductModel.h"

@interface ECConfirmOrderFactoryHeader ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation ECConfirmOrderFactoryHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self addSubview:_titleLabel];
    _titleLabel.font = FONT_32;
    _titleLabel.textColor = LightMoreColor;
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    [self addSubview:_contentLabel];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_line) {
        _line = [UIView new];
    }
    [self addSubview:_line];
    _line.backgroundColor = BaseColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(1.f);
    }];
    
}

- (void)setModel:(ECCartFactoryModel *)model {
    WEAK_SELF
    _model = model;
    
    _titleLabel.text = model.seller;
    CGFloat width = [CMPublicMethod getWidthWithLabel:_titleLabel];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(12.f);
        make.top.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(width);
    }];
    
    __block CGFloat price = 0;
    __block NSInteger productCount = 0;
    [model.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull productModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *currPrice = nil;
        productCount += productModel.count.integerValue;
        if (productModel.useQcode) {
            //使用Q码或会员价
            if (productModel.useEasyPay) {
                //使用分期
                currPrice = productModel.nowVipPay;
            } else {
                //不使用分期
                currPrice = productModel.vipPrice;
            }
        } else {
            //不使用Q码或非会员价
            if (productModel.useEasyPay) {
                //使用分期
                currPrice = productModel.nowPay;
            } else {
                //不使用分期
                currPrice = productModel.price;
            }
        }
        price += currPrice.floatValue * productModel.count.integerValue;
    }];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld件商品 共计", productCount]
                                                                                attributes:@{NSFontAttributeName:FONT_28,
                                                                                             NSForegroundColorAttributeName:LightMoreColor}];
    [content appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.0lf", price]
                                                                    attributes:@{NSFontAttributeName:FONT_28,
                                                                                 NSForegroundColorAttributeName:DarkMoreColor}]];
    _contentLabel.attributedText = content;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel.mas_left).offset(10.f);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-12.f);
        make.top.bottom.mas_equalTo(weakSelf);
    }];
}


@end
