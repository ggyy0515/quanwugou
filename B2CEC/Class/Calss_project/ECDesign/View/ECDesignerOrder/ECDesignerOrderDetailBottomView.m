//
//  ECDesignerOrderDetailBottomView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderDetailBottomView.h"

@interface ECDesignerOrderDetailBottomView()

@property (strong,nonatomic) UIView *lineView1;

@property (strong,nonatomic) UILabel *moneyLab;

@property (strong,nonatomic) UIButton *leftBtn;

@property (strong,nonatomic) UIButton *rightBtn;

@property (assign,nonatomic) NSInteger leftType;
@property (assign,nonatomic) NSInteger rightType;

@end

@implementation ECDesignerOrderDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    WEAK_SELF
    if (!_moneyLab) {
        _moneyLab = [UILabel new];
    }
    
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
    }
    _leftBtn.titleLabel.font = FONT_28;
    _leftBtn.layer.cornerRadius = 4.f;
    _leftBtn.layer.masksToBounds = YES;
    [_leftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickOperationBlock) {
            weakSelf.clickOperationBlock(weakSelf.leftType);
        }
    }];
    
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
    }
    _rightBtn.titleLabel.font = FONT_28;
    _rightBtn.layer.cornerRadius = 4.f;
    _rightBtn.layer.masksToBounds = YES;
    [_rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickOperationBlock) {
            weakSelf.clickOperationBlock(weakSelf.rightType);
        }
    }];
    
    if (!_lineView1) {
        _lineView1 = [UIView new];
    }
    _lineView1.backgroundColor = LineDefaultsColor;
    
    [self addSubview:_moneyLab];
    [self addSubview:_leftBtn];
    [self addSubview:_rightBtn];
    [self addSubview:_lineView1];
    
    [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90.f, 32.f));
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(weakSelf.rightBtn.mas_left).offset(-12.f);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(weakSelf.leftBtn);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

//0:白底黑字黑边  1：黑底白字无边
- (void)setBtnUI:(UIButton *)btn WithType:(NSInteger)type WithTitle:(NSString *)title{
    [btn setTitle:title forState:UIControlStateNormal];
    switch (type) {
        case -1:{
            [btn setTitleColor:LightColor forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = ClearColor.CGColor;
            btn.layer.borderWidth = 0.f;
            btn.enabled = NO;
        }
            break;
        case 0:{
            [btn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = UIColorFromHexString(@"c7c7c7").CGColor;
            btn.layer.borderWidth = 1.f;
            btn.enabled = YES;
        }
            break;
        case 1:{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = MainColor;
            btn.layer.borderColor = ClearColor.CGColor;
            btn.layer.borderWidth = 0.f;
            btn.enabled = YES;
        }
            break;
        default:{
            
        }
            break;
    }
}

- (NSAttributedString *)getMoneyAttriStr:(NSString *)money{
    money = [NSString stringWithFormat:@"%.2f",[money floatValue]];
    NSMutableAttributedString *attStr = [NSMutableAttributedString new];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"报价：￥" attributes:@{NSFontAttributeName:FONT_28,NSForegroundColorAttributeName:DarkMoreColor}]];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[money substringToIndex:money.length - 3] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.f],NSForegroundColorAttributeName:DarkMoreColor}]];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[money substringFromIndex:money.length - 3] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:DarkMoreColor}]];
    return attStr;
}

- (void)setIsDesigner:(BOOL)isDesigner{
    _isDesigner = isDesigner;
}

- (void)setModel:(ECDesignerOrderDetailModel *)model{
    _model = model;
    if (_isDesigner) {
        if ([model.state isEqualToString:@"yixiadan"]) {//待接单
            _moneyLab.hidden = YES;
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _leftType = 0;
            _rightType = 1;
            
            [self setBtnUI:_leftBtn WithType:0 WithTitle:@"婉拒"];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"报价接单"];
        }else if ([model.state isEqualToString:@"daiqueren"]){//已报价
            _moneyLab.hidden = NO;
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _leftType = 0;
            _rightType = 9;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_leftBtn WithType:0 WithTitle:@"取消"];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"修改"];
        }else if ([model.state isEqualToString:@"jinxingzhong"]){//进行中
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _rightType = 5;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"确认完工"];
        }else if ([model.state isEqualToString:@"Designer_complate"]){//设计师完成
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"待用户确认"];
        }else if ([model.state isEqualToString:@"daipingjia"] || [model.state isEqualToString:@"complate"]){//待评价//已完成
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已完成"];
        }else if ([model.state isEqualToString:@"yiquxiao"]){//已取消
            _moneyLab.hidden = YES;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已取消"];
        }else if ([model.state isEqualToString:@"reback_money_ing"]){//退款中
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"退款中"];
        }else if ([model.state isEqualToString:@"yituikuan"]){//已退款
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已退款"];
        }
    }else{
        if ([model.state isEqualToString:@"yixiadan"]) {//已下单
            _moneyLab.hidden = YES;
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _leftType = 2;
            _rightType = 3;
            
            [self setBtnUI:_leftBtn WithType:0 WithTitle:@"取消订单"];
            [self setBtnUI:_rightBtn WithType:0 WithTitle:@"修改"];
        }else if ([model.state isEqualToString:@"daiqueren"]){//待确认
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _rightType = 4;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"确认并支付"];
        }else if ([model.state isEqualToString:@"jinxingzhong"] || [model.state isEqualToString:@"Designer_complate"]){//进行中//设计师完成
            _moneyLab.hidden = NO;
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _leftType = 7;
            _rightType = 6;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_leftBtn WithType:0 WithTitle:@"申请退款"];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"确认完工"];
        }else if ([model.state isEqualToString:@"daipingjia"]){//待评价
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _rightType = 8;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"去评价"];
        }else if ([model.state isEqualToString:@"complate"]){//已完成
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已完成"];
        }else if ([model.state isEqualToString:@"yiquxiao"]){//已取消
            _moneyLab.hidden = YES;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已取消"];
        }else if ([model.state isEqualToString:@"reback_money_ing"]){//退款中
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"退款中"];
        }else if ([model.state isEqualToString:@"yituikuan"]){//已退款
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已退款"];
        }
    }
}

@end
