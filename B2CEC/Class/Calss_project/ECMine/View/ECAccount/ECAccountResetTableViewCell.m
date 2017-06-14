//
//  ECAccountResetTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAccountResetTableViewCell.h"

@interface ECAccountResetTableViewCell()

@property (strong,nonatomic) UILabel *tipsLab;

@property (strong,nonatomic) UIView *inputView;

@property (strong,nonatomic) UILabel *loginLab;

@property (strong,nonatomic) UIImageView *loginImageView;

@property (strong,nonatomic) UIButton *loginBtn;

@property (strong,nonatomic) UILabel *payLab;

@property (strong,nonatomic) UIImageView *payImageView;

@property (strong,nonatomic) UIButton *payBtn;

@property (strong,nonatomic) UIView *lineview1;

@property (strong,nonatomic) UIView *lineview2;

@property (strong,nonatomic) UIView *lineview3;

@end

@implementation ECAccountResetTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECAccountResetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAccountResetTableViewCell)];
    if (cell == nil) {
        cell = [[ECAccountResetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAccountResetTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BaseColor;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    WEAK_SELF
    
    if (!_tipsLab) {
        _tipsLab = [UILabel new];
    }
    _tipsLab.font = FONT_32;
    _tipsLab.textColor = DarkMoreColor;
    _tipsLab.textAlignment = NSTextAlignmentCenter;
    
    if (!_inputView) {
        _inputView = [UIView new];
    }
    _inputView.backgroundColor = [UIColor whiteColor];
    
    if (!_loginLab) {
        _loginLab = [UILabel new];
    }
    _loginLab.font = FONT_32;
    _loginLab.textColor = DarkMoreColor;
    
    if (!_loginImageView) {
        _loginImageView = [UIImageView new];
    }
    _loginImageView.image = [UIImage imageNamed:@"enter"];
    
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
    }
    [_loginBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickTypeBlock) {
            weakSelf.clickTypeBlock(0);
        }
    }];
    
    if (!_payLab) {
        _payLab = [UILabel new];
    }
    _payLab.font = FONT_32;
    _payLab.textColor = DarkMoreColor;
    
    if (!_payImageView) {
        _payImageView = [UIImageView new];
    }
    _payImageView.image = [UIImage imageNamed:@"enter"];
    
    if (!_payBtn) {
        _payBtn = [UIButton new];
    }
    [_payBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickTypeBlock) {
            weakSelf.clickTypeBlock(1);
        }
    }];
    
    if (!_lineview1) {
        _lineview1 = [UIView new];
    }
    _lineview1.backgroundColor = LineDefaultsColor;
    
    if (!_lineview2) {
        _lineview2 = [UIView new];
    }
    _lineview2.backgroundColor = LineDefaultsColor;
    
    if (!_lineview3) {
        _lineview3 = [UIView new];
    }
    _lineview3.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_tipsLab];
    [self.contentView addSubview:_inputView];
    [_inputView addSubview:_loginLab];
    [_inputView addSubview:_loginImageView];
    [_inputView addSubview:_loginBtn];
    [_inputView addSubview:_payLab];
    [_inputView addSubview:_payImageView];
    [_inputView addSubview:_payBtn];
    [_inputView addSubview:_lineview1];
    [_inputView addSubview:_lineview2];
    [_inputView addSubview:_lineview3];
    
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(76.f);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.tipsLab.mas_bottom);
        make.height.mas_equalTo(52.f * 2);
    }];
    
    [_loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(0.f);
        make.height.mas_equalTo(52.f);
    }];
    
    [_loginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.loginLab.mas_centerY);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(weakSelf.loginLab);
        make.right.equalTo(weakSelf.loginImageView);
    }];
    
    [_payLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(52.f);
    }];
    
    [_payImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.payLab.mas_centerY);
    }];
    
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(weakSelf.payLab);
        make.right.equalTo(weakSelf.payImageView);
    }];
    
    [_lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_lineview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.lineview1);
        make.centerY.mas_equalTo(weakSelf.inputView.mas_centerY);
    }];
    
    [_lineview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.lineview1);
        make.bottom.mas_equalTo(0.f);
    }];
}

- (void)setType:(NSInteger)type{
    _type = type;
    switch (type) {
        case 0:{
            _tipsLab.text = [NSString stringWithFormat:@"您正在修改%@的登录密码",[CMPublicMethod mobilePhoneNumberIntoAStarMobile:[Keychain objectForKey:EC_PHONE]]];
            _loginLab.text = @"我记得原登录密码";
            _payLab.text = @"我忘记登录密码了";
        }
            break;
        default:{
            _tipsLab.text = [NSString stringWithFormat:@"您正在修改%@的支付密码",[CMPublicMethod mobilePhoneNumberIntoAStarMobile:[Keychain objectForKey:EC_PHONE]]];
            _loginLab.text = @"我记得原支付密码";
            _payLab.text = @"我忘记支付密码了";
        }
            break;
    }
}

@end
