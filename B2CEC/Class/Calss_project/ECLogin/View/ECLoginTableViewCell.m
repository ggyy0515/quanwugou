//
//  ECLoginTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECLoginTableViewCell.h"

@interface ECLoginTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UITextField *mobileTF;

@property (strong,nonatomic) UIView *mobileLineView;

@property (strong,nonatomic) UITextField *passwordTF;

@property (strong,nonatomic) UIView *passwordLineView;

@property (strong,nonatomic) UIButton *secureBtn;

@property (strong,nonatomic) UIButton *loginBtn;

@property (strong,nonatomic) UIButton *registerBtn;

@property (strong,nonatomic) UIButton *forgetPasswordBtn;

@property (strong,nonatomic) UIView *otherLineView;

@property (strong,nonatomic) UILabel *otherLab;

@property (strong,nonatomic) UIButton *weixinBtn;

@property (strong,nonatomic) UIButton *qqBtn;

@end

@implementation ECLoginTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLoginTableViewCell)];
    if (cell == nil) {
        cell = [[ECLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLoginTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
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
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"logo"];
    
    if (!_mobileTF) {
        _mobileTF = [UITextField new];
    }
    _mobileTF.placeholder = @"请输入手机号";
    _mobileTF.font = FONT_32;
    _mobileTF.textColor = DarkMoreColor;
    [_mobileTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    
    if (!_mobileLineView) {
        _mobileLineView = [UIView new];
    }
    _mobileLineView.backgroundColor = LineDefaultsColor;
    
    if (!_passwordTF) {
        _passwordTF = [UITextField new];
    }
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.font = FONT_32;
    _passwordTF.textColor = DarkMoreColor;
    [_passwordTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _passwordTF.secureTextEntry = YES;
    
    if (!_secureBtn) {
        _secureBtn = [UIButton new];
    }
    [_secureBtn setImage:[UIImage imageNamed:@"login_display_off"] forState:UIControlStateNormal];
    [_secureBtn setImage:[UIImage imageNamed:@"login_display_on"] forState:UIControlStateSelected];
    [_secureBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.passwordTF.secureTextEntry = sender.selected;
        sender.selected = !sender.selected;
        
    }];
    
    if (!_passwordLineView) {
        _passwordLineView = [UIView new];
    }
    _passwordLineView.backgroundColor = LineDefaultsColor;
    
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
    }
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_loginBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (![WJRegularVerify phoneNumberVerify:weakSelf.mobileTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入有效的手机号码"];
            return ;
        }
        if (weakSelf.passwordTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        if (weakSelf.loginBlock) {
            weakSelf.loginBlock(weakSelf.mobileTF.text,weakSelf.passwordTF.text);
        }
    }];
    
    if (!_registerBtn) {
        _registerBtn = [UIButton new];
    }
    [_registerBtn setTitle:@"还没有账号？快速注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = FONT_28;
    [_registerBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.registerBlock) {
            weakSelf.registerBlock();
        }
    }];
    
    if (!_forgetPasswordBtn) {
        _forgetPasswordBtn = [UIButton new];
    }
    [_forgetPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPasswordBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _forgetPasswordBtn.titleLabel.font = FONT_28;
    [_forgetPasswordBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.forgetPasswordBlock) {
            weakSelf.forgetPasswordBlock();
        }
    }];
    
    if (!_otherLineView) {
        _otherLineView = [UIView new];
    }
    _otherLineView.backgroundColor = LineDefaultsColor;
    
    if (!_otherLab) {
        _otherLab = [UILabel new];
    }
    _otherLab.text = @"第三方账号登录";
    _otherLab.textColor = LightColor;
    _otherLab.font = FONT_28;
    _otherLab.textAlignment = NSTextAlignmentCenter;
    _otherLab.backgroundColor = [UIColor whiteColor];
    
    if (!_weixinBtn) {
        _weixinBtn = [UIButton new];
    }
    [_weixinBtn setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    [_weixinBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.weixinLoginBlock) {
            weakSelf.weixinLoginBlock();
        }
    }];
    
    if (!_qqBtn) {
        _qqBtn = [UIButton new];
    }
    [_qqBtn setImage:[UIImage imageNamed:@"login_QQ"] forState:UIControlStateNormal];
    [_qqBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.qqLoginBlock) {
            weakSelf.qqLoginBlock();
        }
    }];
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_mobileTF];
    [self.contentView addSubview:_mobileLineView];
    [self.contentView addSubview:_passwordTF];
    [self.contentView addSubview:_secureBtn];
    [self.contentView addSubview:_passwordLineView];
    [self.contentView addSubview:_loginBtn];
    [self.contentView addSubview:_registerBtn];
    [self.contentView addSubview:_forgetPasswordBtn];
    [self.contentView addSubview:_otherLineView];
    [self.contentView addSubview:_otherLab];
    [self.contentView addSubview:_weixinBtn];
    [self.contentView addSubview:_qqBtn];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90.f, 90.f));
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(44.f);
    }];
    
    [_mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(177.f);
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.height.mas_equalTo(49.f);
    }];
    
    [_mobileLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.mobileTF);
        make.height.mas_equalTo(0.5f);
        make.top.mas_equalTo(weakSelf.mobileTF.mas_bottom);
    }];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(weakSelf.mobileTF);
        make.right.mas_equalTo(weakSelf.secureBtn.mas_left).offset(-10.f);
        make.top.mas_equalTo(weakSelf.mobileLineView.mas_bottom).offset(8.f);
    }];
    
    [_secureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30.f);
        make.centerY.mas_equalTo(weakSelf.passwordTF.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    [_passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.mobileLineView);
        make.top.mas_equalTo(weakSelf.passwordTF.mas_bottom);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.mobileTF);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(weakSelf.passwordLineView.mas_bottom).offset(44.f);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mobileTF);
        make.top.mas_equalTo(weakSelf.loginBtn.mas_bottom).offset(4.f);
    }];
    
    [_forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mobileTF);
        make.top.equalTo(weakSelf.registerBtn).offset(4.f);
    }];
    
    [_otherLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.mobileLineView);
        make.top.mas_equalTo(weakSelf.registerBtn.mas_bottom).offset(72.f);
    }];
    
    [_otherLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(weakSelf.otherLineView);
        make.width.mas_equalTo(123.f);
    }];
    
    [_weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
        make.right.mas_equalTo(weakSelf.mas_centerX).offset(-24.f);
        make.top.mas_equalTo(weakSelf.otherLineView.mas_bottom).offset(32.f);
    }];
    
    [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(weakSelf.weixinBtn);
        make.left.mas_equalTo(weakSelf.mas_centerX).offset(24.f);
    }];
}

@end
