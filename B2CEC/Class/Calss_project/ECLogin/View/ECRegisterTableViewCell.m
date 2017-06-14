//
//  ECRegisterTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECRegisterTableViewCell.h"

@interface ECRegisterTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UITextField *mobileTF;

@property (strong,nonatomic) UIView *mobileLineView;

@property (strong,nonatomic) UITextField *passwordTF;

@property (strong,nonatomic) UIView *passwordLineView;

@property (strong,nonatomic) UIButton *secureBtn;

@property (strong,nonatomic) UITextField *verficationTF;

@property (strong,nonatomic) UIView *verficationLineView;

@property (strong,nonatomic) UIButton *getVerficationBtn;

@property (strong,nonatomic) UIButton *registerBtn;

@property (strong,nonatomic) UIButton *loginBtn;

@property (strong,nonatomic) UIButton *agreementBtn;

@property (assign,nonatomic) BOOL isGetVerfication;

@end

@implementation ECRegisterTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECRegisterTableViewCell)];
    if (cell == nil) {
        cell = [[ECRegisterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECRegisterTableViewCell)];
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
    _isGetVerfication = NO;
    
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
    
    if (!_verficationTF) {
        _verficationTF = [UITextField new];
    }
    _verficationTF.placeholder = @"请输入验证码";
    _verficationTF.font = FONT_32;
    _verficationTF.textColor = DarkMoreColor;
    [_verficationTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _verficationTF.keyboardType = UIKeyboardTypeNumberPad;
    
    if (!_getVerficationBtn) {
        _getVerficationBtn = [UIButton new];
    }
    [_getVerficationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerficationBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _getVerficationBtn.titleLabel.font = FONT_32;
    _getVerficationBtn.layer.borderColor = MainColor.CGColor;
    _getVerficationBtn.layer.borderWidth = 1.f;
    _getVerficationBtn.layer.cornerRadius = 8.f;
    _getVerficationBtn.layer.masksToBounds = YES;
    [_getVerficationBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (![WJRegularVerify phoneNumberVerify:weakSelf.mobileTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入有效的手机号码"];
            return ;
        }
        if (weakSelf.getVerficationBlock) {
            weakSelf.getVerficationBlock(weakSelf.mobileTF.text);
        }
        weakSelf.isGetVerfication = YES;
        weakSelf.verficationTF.text = @"";
        [CMPublicMethod countDownWithTime:60 WithOperation:^(NSInteger count) {
            [weakSelf.getVerficationBtn setTitle:[NSString stringWithFormat:@"%ldS",(long)count] forState:UIControlStateNormal];
            [weakSelf.getVerficationBtn setTitleColor:LightColor forState:UIControlStateNormal];
            weakSelf.getVerficationBtn.titleLabel.font = FONT_32;
            weakSelf.getVerficationBtn.layer.borderColor = LightColor.CGColor;
            weakSelf.getVerficationBtn.layer.borderWidth = 1.f;
            weakSelf.getVerficationBtn.layer.cornerRadius = 8.f;
            weakSelf.getVerficationBtn.layer.masksToBounds = YES;
            weakSelf.getVerficationBtn.enabled = NO;
        } WithCompletion:^{
            [weakSelf.getVerficationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [weakSelf.getVerficationBtn setTitleColor:MainColor forState:UIControlStateNormal];
            weakSelf.getVerficationBtn.titleLabel.font = FONT_32;
            weakSelf.getVerficationBtn.layer.borderColor = MainColor.CGColor;
            weakSelf.getVerficationBtn.layer.borderWidth = 1.f;
            weakSelf.getVerficationBtn.layer.cornerRadius = 8.f;
            weakSelf.getVerficationBtn.layer.masksToBounds = YES;
            weakSelf.getVerficationBtn.enabled = YES;
        }];
    }];
    
    if (!_verficationLineView) {
        _verficationLineView = [UIView new];
    }
    _verficationLineView.backgroundColor = LineDefaultsColor;
    
    if (!_registerBtn) {
        _registerBtn = [UIButton new];
    }
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_registerBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (![WJRegularVerify phoneNumberVerify:weakSelf.mobileTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入有效的手机号码"];
            return ;
        }
        if (weakSelf.passwordTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        if (weakSelf.passwordTF.text.length < 6 || weakSelf.passwordTF.text.length > 16) {
            [SVProgressHUD showErrorWithStatus:@"请输入6-16位数字字母组合的密码"];
            return;
        }
        if (!weakSelf.isGetVerfication) {
            [SVProgressHUD showErrorWithStatus:@"请先获取验证码"];
            return;
        }
        if (weakSelf.verficationTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        if (weakSelf.registerBlock) {
            weakSelf.registerBlock(weakSelf.mobileTF.text,weakSelf.passwordTF.text,weakSelf.verficationTF.text);
        }
    }];
    
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
    }
    [_loginBtn setTitle:@"已有账号！立即登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = FONT_28;
    [_loginBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.loginBlock) {
            weakSelf.loginBlock();
        }
    }];
    
    if (!_agreementBtn) {
        _agreementBtn = [UIButton new];
    }
    [_agreementBtn setTitle:@"《注册协议》" forState:UIControlStateNormal];
    [_agreementBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _agreementBtn.titleLabel.font = FONT_28;
    [_agreementBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.agreementBlock) {
            weakSelf.agreementBlock();
        }
    }];
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_mobileTF];
    [self.contentView addSubview:_mobileLineView];
    [self.contentView addSubview:_passwordTF];
    [self.contentView addSubview:_secureBtn];
    [self.contentView addSubview:_passwordLineView];
    [self.contentView addSubview:_verficationTF];
    [self.contentView addSubview:_getVerficationBtn];
    [self.contentView addSubview:_verficationLineView];
    [self.contentView addSubview:_registerBtn];
    [self.contentView addSubview:_loginBtn];
    [self.contentView addSubview:_agreementBtn];
    
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
    
    [_verficationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(weakSelf.mobileTF);
        make.top.mas_equalTo(weakSelf.passwordLineView.mas_bottom).offset(8.f);
        make.right.mas_equalTo(weakSelf.getVerficationBtn.mas_left).offset(-10.f);
    }];
    
    [_getVerficationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(107.f, 36.f));
        make.right.mas_equalTo(weakSelf.mobileTF.mas_right);
        make.centerY.mas_equalTo(weakSelf.verficationTF.mas_centerY);
    }];
    
    [_verficationLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.mobileLineView);
        make.top.mas_equalTo(weakSelf.verficationTF.mas_bottom);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.mobileTF);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(weakSelf.verficationLineView.mas_bottom).offset(44.f);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mobileTF);
        make.top.mas_equalTo(weakSelf.registerBtn.mas_bottom).offset(4.f);
    }];
    
    [_agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.bottom.mas_equalTo(-16.f);
    }];
}

@end
