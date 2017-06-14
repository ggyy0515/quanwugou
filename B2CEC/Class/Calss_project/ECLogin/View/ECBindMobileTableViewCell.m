//
//  ECBindMobileTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECBindMobileTableViewCell.h"

@interface ECBindMobileTableViewCell()

@property (strong,nonatomic) UIView *topView;

@property (strong,nonatomic) UIView *topLineView;

@property (strong,nonatomic) UIView *mobileView;

@property (strong,nonatomic) UILabel *mobileLab;

@property (strong,nonatomic) UITextField *mobileTF;

@property (strong,nonatomic) UIView *mobileLineView;

@property (strong,nonatomic) UIView *verficationView;

@property (strong,nonatomic) UILabel *verficationLab;

@property (strong,nonatomic) UITextField *verficationTF;

@property (strong,nonatomic) UIView *verficationRightLineView;

@property (strong,nonatomic) UIButton *getVerficationBtn;

@property (strong,nonatomic) UIView *verficationLineView;

@property (strong,nonatomic) UIView *passwordView;

@property (strong,nonatomic) UILabel *passwordLab;

@property (strong,nonatomic) UITextField *passwordTF;

@property (strong,nonatomic) UIView *passwordLineView;

@property (strong,nonatomic) UIButton *confirmStepBtn;

@property (assign,nonatomic) BOOL isGetVerfication;

@end

@implementation ECBindMobileTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECBindMobileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECBindMobileTableViewCell)];
    if (cell == nil) {
        cell = [[ECBindMobileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECBindMobileTableViewCell)];
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
    _isGetVerfication = NO;
    
    if (!_topView) {
        _topView = [UIView new];
    }
    _topView.backgroundColor = BaseColor;
    
    if (!_topLineView) {
        _topLineView = [UIView new];
    }
    _topLineView.backgroundColor = LineDefaultsColor;
    
    if (!_mobileView) {
        _mobileView = [UIView new];
    }
    _mobileView.backgroundColor = [UIColor whiteColor];
    
    if (!_mobileLab) {
        _mobileLab = [UILabel new];
    }
    _mobileLab.text = @"手机号：";
    _mobileLab.textColor = DarkMoreColor;
    _mobileLab.font = FONT_32;
    
    if (!_mobileTF) {
        _mobileTF = [UITextField new];
    }
    _mobileTF.placeholder = @"请输入手机号";
    [_mobileTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _mobileTF.font = FONT_32;
    _mobileTF.textColor = DarkMoreColor;
    
    if (!_mobileLineView) {
        _mobileLineView = [UIView new];
    }
    _mobileLineView.backgroundColor = LineDefaultsColor;
    
    if (!_verficationView) {
        _verficationView = [UIView new];
    }
    _verficationView.backgroundColor = [UIColor whiteColor];
    
    if (!_verficationLab) {
        _verficationLab = [UILabel new];
    }
    _verficationLab.text = @"验证码：";
    _verficationLab.textColor = DarkMoreColor;
    _verficationLab.font = FONT_32;
    
    if (!_verficationTF) {
        _verficationTF = [UITextField new];
    }
    _verficationTF.placeholder = @"请输入验证码";
    [_verficationTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _verficationTF.font = FONT_32;
    _verficationTF.textColor = DarkMoreColor;
    
    if (!_verficationRightLineView) {
        _verficationRightLineView = [UIView new];
    }
    _verficationRightLineView.backgroundColor = LineDefaultsColor;
    
    if (!_getVerficationBtn) {
        _getVerficationBtn = [UIButton new];
    }
    [_getVerficationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerficationBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [_getVerficationBtn setTitleColor:LightColor forState:UIControlStateDisabled];
    _getVerficationBtn.titleLabel.font = FONT_28;
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
        weakSelf.getVerficationBtn.enabled = NO;
        [CMPublicMethod countDownWithTime:60 WithOperation:^(NSInteger count) {
            [weakSelf.getVerficationBtn setTitle:[NSString stringWithFormat:@"%ldS",(long)count] forState:UIControlStateNormal];
        } WithCompletion:^{
            [weakSelf.getVerficationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            weakSelf.getVerficationBtn.enabled = YES;
        }];
    }];
    
    if (!_verficationLineView) {
        _verficationLineView = [UIView new];
    }
    _verficationLineView.backgroundColor = LineDefaultsColor;
    
    if (!_passwordView) {
        _passwordView = [UIView new];
    }
    _passwordView.backgroundColor = [UIColor whiteColor];
    
    if (!_passwordLab) {
        _passwordLab = [UILabel new];
    }
    _passwordLab.text = @"密   码：";
    _passwordLab.textColor = DarkMoreColor;
    _passwordLab.font = FONT_32;
    
    if (!_passwordTF) {
        _passwordTF = [UITextField new];
    }
    _passwordTF.placeholder = @"6-16位字母数字组合";
    [_passwordTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _passwordTF.font = FONT_32;
    _passwordTF.textColor = DarkMoreColor;
    
    if (!_passwordLineView) {
        _passwordLineView = [UIView new];
    }
    _passwordLineView.backgroundColor = LineDefaultsColor;
    
    if (!_confirmStepBtn) {
        _confirmStepBtn = [UIButton new];
    }
    [_confirmStepBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmStepBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    _confirmStepBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_confirmStepBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
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
        if (weakSelf.nextStepBlock) {
            weakSelf.nextStepBlock(weakSelf.mobileTF.text,weakSelf.passwordTF.text,weakSelf.verficationTF.text);
        }
    }];
    
    [self.contentView addSubview:_topView];
    [self.contentView addSubview:_topLineView];
    [self.contentView addSubview:_mobileView];
    [_mobileView addSubview:_mobileLab];
    [_mobileView addSubview:_mobileTF];
    [self.contentView addSubview:_mobileLineView];
    [self.contentView addSubview:_verficationView];
    [_verficationView addSubview:_verficationLab];
    [_verficationView addSubview:_verficationTF];
    [_verficationView addSubview:_verficationRightLineView];
    [_verficationView addSubview:_getVerficationBtn];
    [self.contentView addSubview:_verficationLineView];
    [self.contentView addSubview:_passwordView];
    [_passwordView addSubview:_passwordLab];
    [_passwordView addSubview:_passwordTF];
    [self.contentView addSubview:_passwordLineView];
    [self.contentView addSubview:_confirmStepBtn];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(8.f);
    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom);
    }];
    
    [_mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.topLineView.mas_bottom);
        make.height.mas_equalTo(44.f);
    }];
    
    [_mobileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
        make.width.mas_equalTo(70.f);
    }];
    
    [_mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.mobileLab.mas_right).offset(12.f);
    }];
    
    [_mobileLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.topLineView);
        make.top.mas_equalTo(weakSelf.mobileView.mas_bottom);
    }];
    
    [_verficationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(weakSelf.mobileView);
        make.top.mas_equalTo(weakSelf.mobileLineView.mas_bottom);
    }];
    
    [_verficationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
        make.width.equalTo(weakSelf.mobileLab);
    }];
    
    [_verficationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.verficationLab.mas_right).offset(12.f);
        make.right.mas_equalTo(weakSelf.verficationRightLineView.mas_left).offset(-12.f);
    }];
    
    [_verficationRightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.getVerficationBtn.mas_left);
        make.width.mas_equalTo(0.5f);
    }];
    
    [_getVerficationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0.f);
        make.width.mas_equalTo(100.f);
    }];
    
    [_verficationLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.topLineView);
        make.top.mas_equalTo(weakSelf.verficationView.mas_bottom);
    }];
    
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.mobileView);
        make.top.mas_equalTo(weakSelf.verficationLineView.mas_bottom);
    }];
    
    [_passwordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
        make.width.equalTo(weakSelf.mobileLab);
    }];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0.f);
        make.left.equalTo(weakSelf.passwordLab.mas_right).offset(12.f);
    }];
    
    [_passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.topLineView);
        make.top.mas_equalTo(weakSelf.passwordView.mas_bottom);
    }];
    
    [_confirmStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(weakSelf.passwordLineView.mas_bottom).offset(32.f);
    }];
}

@end
