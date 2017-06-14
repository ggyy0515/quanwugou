//
//  ECOrderSingleProductCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderSingleProductCell.h"
#import "ECMallDataParser.h"
#import "ECOrderListModel.h"
#import "ECOrderProductModel.h"

@interface ECOrderSingleProductCell ()

@property (nonatomic, strong) UILabel *orderNumLabel;
@property (nonatomic, strong) UILabel *orderStateLabel;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation ECOrderSingleProductCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_orderNumLabel) {
        _orderNumLabel = [UILabel new];
    }
    [self.contentView addSubview:_orderNumLabel];
    _orderNumLabel.font = FONT_28;
    _orderNumLabel.textColor = LightMoreColor;
    
    if (!_orderStateLabel) {
        _orderStateLabel = [UILabel new];
    }
    [self.contentView addSubview:_orderStateLabel];
    _orderStateLabel.font = FONT_28;
    _orderStateLabel.textColor = DarkMoreColor;
    _orderStateLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_line1) {
        _line1 = [UIView new];
    }
    [self.contentView addSubview:_line1];
    _line1.backgroundColor = BaseColor;
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.textColor = LightMoreColor;
    _nameLabel.font = FONT_28;
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self.contentView addSubview:_priceLabel];
    
    if (!_descLabel) {
        _descLabel = [UILabel new];
    }
    [self.contentView addSubview:_descLabel];
    _descLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_line2) {
        _line2 = [UIView new];
    }
    [self.contentView addSubview:_line2];
    _line2.backgroundColor = BaseColor;
    
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
    }
    [self.contentView addSubview:_rightBtn];
    _rightBtn.hidden = YES;
    _rightBtn.layer.cornerRadius = 4.f;
    _rightBtn.layer.borderWidth = 1.f;
    _rightBtn.titleLabel.font = FONT_28;
    [_rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickActionBtn) {
            weakSelf.clickActionBtn(sender.titleLabel.text);
        }
    }];
    
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
    }
    [self.contentView addSubview:_leftBtn];
    _leftBtn.hidden = YES;
    _leftBtn.layer.cornerRadius = 4.f;
    _leftBtn.layer.borderWidth = 1.f;
    _leftBtn.titleLabel.font = FONT_28;
    [_leftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickActionBtn) {
            weakSelf.clickActionBtn(sender.titleLabel.text);
        }
    }];
    
    if (!_bottomLabel) {
        _bottomLabel = [UILabel new];
    }
    [self.contentView addSubview:_bottomLabel];
    _bottomLabel.textColor = LightColor;
    _bottomLabel.font = FONT_28;
    _bottomLabel.textAlignment = NSTextAlignmentRight;
    _bottomLabel.hidden = YES;
    
}

- (void)setModel:(ECOrderListModel *)model {
    _model = model;
    WEAK_SELF
    
    _orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@", model.orderNo];
    CGFloat width = [CMPublicMethod getWidthWithLabel:_orderNumLabel];
    [_orderNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (weakSelf.contentView.mas_left).offset(12.f);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.orderNumLabel.font.lineHeight));
    }];
    
    _orderStateLabel.text = [ECMallDataParser getOrderStateTitleWithMainStateString:model.state subStateString:model.subState];
    [_orderStateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderNumLabel.mas_right).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.height.mas_equalTo(weakSelf.orderStateLabel.font.lineHeight);
        make.centerY.mas_equalTo(weakSelf.orderNumLabel.mas_centerY);
    }];
    
    [_line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.orderNumLabel.mas_bottom).offset(12.f);
        make.height.mas_equalTo(1.f);
    }];
    
    ECOrderProductModel *productModel = [model.productList objectAtIndexWithCheck:0];
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(productModel.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.line1.mas_bottom).offset(12.f);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(60.f, 60.f));
    }];
    
    _nameLabel.text = productModel.name;
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.imageView.mas_top).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
    }];
    
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%ld", productModel.amount.integerValue / productModel.count.integerValue]
                                                                                 attributes:@{NSFontAttributeName:FONT_28,
                                                                                              NSForegroundColorAttributeName:DarkMoreColor}];
    [priceAtt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@", productModel.count]
                                                                     attributes:@{NSFontAttributeName:FONT_28,
                                                                                  NSForegroundColorAttributeName:LightMoreColor}]];
    _priceLabel.attributedText = priceAtt;
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(12.f);
        make.height.mas_equalTo(14.f);
    }];
    
    NSMutableAttributedString *descAtt = [[NSMutableAttributedString alloc] initWithString:@"共"
                                                                                attributes:@{NSFontAttributeName:FONT_28,
                                                                                             NSForegroundColorAttributeName:LightColor}];
    [descAtt appendAttributedString:[[NSAttributedString alloc] initWithString:productModel.count
                                                                    attributes:@{NSFontAttributeName:FONT_28,
                                                                                 NSForegroundColorAttributeName:DarkMoreColor}]];
    [descAtt appendAttributedString:[[NSAttributedString alloc] initWithString:@"件 合计"
                                                                    attributes:@{NSFontAttributeName:FONT_28,
                                                                                 NSForegroundColorAttributeName:LightColor}]];
    [descAtt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%ld", model.nowPay.integerValue + model.leftPay.integerValue]
                                                                    attributes:@{NSFontAttributeName:FONT_28,
                                                                                 NSForegroundColorAttributeName:DarkMoreColor}]];
    if (model.leftPay.integerValue > 0 && [model.state isEqualToString:@"For_the_payment"]) {
        [descAtt appendAttributedString:[[NSAttributedString alloc] initWithString:@" 剩余尾款"
                                                                        attributes:@{NSFontAttributeName:FONT_28,
                                                                                     NSForegroundColorAttributeName:LightColor}]];
        [descAtt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model.leftPay]
                                                                        attributes:@{NSFontAttributeName:FONT_28,
                                                                                     NSForegroundColorAttributeName:DarkMoreColor}]];
    }
    _descLabel.attributedText = descAtt;
    [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.height.mas_equalTo(14.f);
    }];
    
    [_line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.descLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(1.f);
    }];
    
    [_rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.top.mas_equalTo(weakSelf.line2.mas_bottom).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(80.f, 34.f));
    }];
    
    [_leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.rightBtn.mas_top);
        make.right.mas_equalTo(weakSelf.rightBtn.mas_left).offset(-16.f);
        make.size.mas_equalTo(CGSizeMake(80.f, 34.f));
    }];
    
    [_bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.mas_equalTo(weakSelf.rightBtn);
        make.height.mas_equalTo(weakSelf.bottomLabel.font.lineHeight);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
    }];
    
    [self configBtnsWithMainState:model.state subState:model.subState];
    
}

- (void)configBtnsWithMainState:(NSString *)mainStateString subState:(NSString *)subStateString {
    if ([mainStateString isEqualToString:@"For_the_payment"]) {
        if ([subStateString isEqualToString:@"daijiedan"]) {
            //待接单
            [_rightBtn setTitle:@"支付尾款" forState:UIControlStateNormal];
            [_rightBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
            _rightBtn.layer.borderColor = LightColor.CGColor;
            _rightBtn.hidden = NO;
            
            [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_leftBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
            _leftBtn.layer.borderColor = LightColor.CGColor;
            _leftBtn.hidden = NO;
            
            _bottomLabel.hidden = YES;
        }
        else if ([subStateString isEqualToString:@"gongchangjiedan"]) {
            //工厂接单 @"生产中"
            [_rightBtn setTitle:@"支付尾款" forState:UIControlStateNormal];
            [_rightBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
            _rightBtn.layer.borderColor = LightColor.CGColor;
            _rightBtn.hidden = NO;
            
            _leftBtn.hidden = YES;
            
            _bottomLabel.hidden = YES;
        }
        else if ([subStateString isEqualToString:@"shengchanwancheng"]) {
            //生产完成
            [_rightBtn setTitle:@"支付尾款" forState:UIControlStateNormal];
            [_rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
            _rightBtn.layer.borderColor = MainColor.CGColor;
            _rightBtn.hidden = NO;
            
            _leftBtn.hidden = YES;
            
            _bottomLabel.hidden = YES;
        }
        else if ([subStateString isEqualToString:@"daifuweikuan"]) {
            //待付尾款
            [_rightBtn setTitle:@"支付尾款" forState:UIControlStateNormal];
            [_rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
            _rightBtn.layer.borderColor = MainColor.CGColor;
            _rightBtn.hidden = NO;
            
            _leftBtn.hidden = YES;
            
            _bottomLabel.hidden = YES;
        }
        else {
            //待付款(subStateString是@"")
            [_rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
            [_rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
            _rightBtn.layer.borderColor = MainColor.CGColor;
            _rightBtn.hidden = NO;
            
            [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_leftBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
            _leftBtn.layer.borderColor = LightColor.CGColor;
            _leftBtn.hidden = NO;
            
            _bottomLabel.hidden = YES;
        }
    }
    
    else if ([mainStateString isEqualToString:@"To_send_the_goods"]) {
        //代发货
        _rightBtn.hidden = YES;
        _leftBtn.hidden = YES;
        _bottomLabel.hidden = NO;
        _bottomLabel.text = @"卖家正在出货中";
    }
    else if ([mainStateString isEqualToString:@"For_the_goods"]) {
        //待收货
        [_rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _rightBtn.layer.borderColor = MainColor.CGColor;
        _rightBtn.hidden = NO;
        
        [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
        _leftBtn.layer.borderColor = LightColor.CGColor;
        _leftBtn.hidden = NO;
        
        _bottomLabel.hidden = YES;
    }
    else if ([mainStateString isEqualToString:@"For_the_Comment"]) {
        //待评价
        [_rightBtn setTitle:@"立即评价" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _rightBtn.layer.borderColor = MainColor.CGColor;
        _rightBtn.hidden = NO;
        
        [_leftBtn setTitle:@"申请退货" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
        _leftBtn.layer.borderColor = LightColor.CGColor;
        if (_model.canReturn.integerValue == 0) {
            _leftBtn.hidden = NO;
        } else {
            _leftBtn.hidden = YES;
        }
        
        
        _bottomLabel.hidden = YES;
    }
    else if ([mainStateString isEqualToString:@"Return"]) {
        if ([subStateString isEqualToString:@"In_Return"]) {
            //退货中
            _rightBtn.hidden = YES;
            _leftBtn.hidden = YES;
            _bottomLabel.hidden = NO;
            _bottomLabel.text = @"待卖家确认";
        }
        else {
            //已退货
            _rightBtn.hidden = YES;
            _leftBtn.hidden = YES;
            _bottomLabel.hidden = NO;
            _bottomLabel.text = @"已完成退货";
        }
    }
    else if ([mainStateString isEqualToString:@"Complete"]) {
        //交易完成
        [_rightBtn setTitle:@"查看评价" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _rightBtn.layer.borderColor = MainColor.CGColor;
        _rightBtn.hidden = NO;
        
        [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
        _leftBtn.layer.borderColor = LightColor.CGColor;
        _leftBtn.hidden = NO;
        
        _bottomLabel.hidden = YES;
    }
    else {
        //订单取消
        _leftBtn.hidden = YES;
        _rightBtn.hidden = YES;
        _bottomLabel.hidden = NO;
        _bottomLabel.text = @"订单已取消";
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
