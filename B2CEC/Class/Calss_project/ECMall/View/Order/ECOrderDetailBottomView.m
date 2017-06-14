//
//  ECOrderDetailBottomView.m
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailBottomView.h"
#import "ECOrderListModel.h"


@interface ECOrderDetailBottomView ()

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation ECOrderDetailBottomView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
    }
    [self addSubview:_rightBtn];
    _rightBtn.hidden = YES;
    _rightBtn.layer.cornerRadius = 4.f;
    _rightBtn.layer.borderWidth = 1.f;
    _rightBtn.titleLabel.font = FONT_28;
    [_rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickActionBtn) {
            weakSelf.clickActionBtn(sender.titleLabel.text);
        }
    }];
    [_rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).offset(-12.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80.f, 34.f));
    }];
    
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
    }
    [self addSubview:_leftBtn];
    _leftBtn.hidden = YES;
    _leftBtn.layer.cornerRadius = 4.f;
    _leftBtn.layer.borderWidth = 1.f;
    _leftBtn.titleLabel.font = FONT_28;
    [_leftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickActionBtn) {
            weakSelf.clickActionBtn(sender.titleLabel.text);
        }
    }];
    [_leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.rightBtn.mas_top);
        make.right.mas_equalTo(weakSelf.rightBtn.mas_left).offset(-16.f);
        make.size.mas_equalTo(CGSizeMake(80.f, 34.f));
    }];
    
    if (!_bottomLabel) {
        _bottomLabel = [UILabel new];
    }
    [self addSubview:_bottomLabel];
    _bottomLabel.textColor = LightColor;
    _bottomLabel.font = FONT_28;
    _bottomLabel.textAlignment = NSTextAlignmentRight;
    _bottomLabel.hidden = YES;
    [_bottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.mas_equalTo(weakSelf.rightBtn);
        make.height.mas_equalTo(weakSelf.bottomLabel.font.lineHeight);
        make.left.mas_equalTo(weakSelf.mas_left).offset(12.f);
    }];

}

- (void)setModel:(ECOrderListModel *)model {
    _model = model;
    
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
