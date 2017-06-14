//
//  ECResetPasswordTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECResetPasswordTableViewCell.h"

@interface ECResetPasswordTableViewCell()

@property (strong,nonatomic) UIView *topView;

@property (strong,nonatomic) UIView *topLineView;

@property (strong,nonatomic) UIView *passwordView;

@property (strong,nonatomic) UILabel *passwordLab;

@property (strong,nonatomic) UITextField *passwordTF;

@property (strong,nonatomic) UIView *passwordLineView;

@property (strong,nonatomic) UIView *passwordAgainView;

@property (strong,nonatomic) UILabel *passwordAgainLab;

@property (strong,nonatomic) UITextField *passwordAgainTF;

@property (strong,nonatomic) UIView *passwordAgainLineView;

@property (strong,nonatomic) UIButton *confirmStepBtn;

@end

@implementation ECResetPasswordTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECResetPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECResetPasswordTableViewCell)];
    if (cell == nil) {
        cell = [[ECResetPasswordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECResetPasswordTableViewCell)];
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
    
    if (!_topView) {
        _topView = [UIView new];
    }
    _topView.backgroundColor = BaseColor;
    
    if (!_topLineView) {
        _topLineView = [UIView new];
    }
    _topLineView.backgroundColor = LineDefaultsColor;
    
    if (!_passwordView) {
        _passwordView = [UIView new];
    }
    _passwordView.backgroundColor = [UIColor whiteColor];
    
    if (!_passwordLab) {
        _passwordLab = [UILabel new];
    }
    _passwordLab.text = @"新的密码：";
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
    
    if (!_passwordAgainView) {
        _passwordAgainView = [UIView new];
    }
    _passwordAgainView.backgroundColor = [UIColor whiteColor];
    
    if (!_passwordAgainLab) {
        _passwordAgainLab = [UILabel new];
    }
    _passwordAgainLab.text = @"确认密码：";
    _passwordAgainLab.textColor = DarkMoreColor;
    _passwordAgainLab.font = FONT_32;
    
    if (!_passwordAgainTF) {
        _passwordAgainTF = [UITextField new];
    }
    _passwordAgainTF.placeholder = @"再次输入您的新密码";
    [_passwordAgainTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _passwordAgainTF.font = FONT_32;
    _passwordAgainTF.textColor = DarkMoreColor;
    
    if (!_passwordAgainLineView) {
        _passwordAgainLineView = [UIView new];
    }
    _passwordAgainLineView.backgroundColor = LineDefaultsColor;
    
    if (!_confirmStepBtn) {
        _confirmStepBtn = [UIButton new];
    }
    [_confirmStepBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmStepBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    _confirmStepBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_confirmStepBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.passwordTF.text.length < 6 || weakSelf.passwordTF.text.length > 16 || weakSelf.passwordAgainTF.text.length < 6 || weakSelf.passwordAgainTF.text.length > 16) {
            [SVProgressHUD showErrorWithStatus:@"请输入6-16位数字字母组合的密码"];
            return ;
        }
        if (![weakSelf.passwordTF.text isEqualToString:weakSelf.passwordAgainTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
            return;
        }
        if (weakSelf.confirmBlock) {
            weakSelf.confirmBlock(weakSelf.passwordTF.text);
        }
    }];
    
    [self.contentView addSubview:_topView];
    [self.contentView addSubview:_topLineView];
    [self.contentView addSubview:_passwordView];
    [_passwordView addSubview:_passwordLab];
    [_passwordView addSubview:_passwordTF];
    [self.contentView addSubview:_passwordLineView];
    [self.contentView addSubview:_passwordAgainView];
    [_passwordAgainView addSubview:_passwordAgainLab];
    [_passwordAgainView addSubview:_passwordAgainTF];
    [self.contentView addSubview:_passwordAgainLineView];
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
    
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.topLineView.mas_bottom);
        make.height.mas_equalTo(44.f);
    }];
    
    [_passwordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
        make.width.mas_equalTo(90.f);
    }];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.passwordLab.mas_right).offset(12.f);
    }];
    
    [_passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.topLineView);
        make.top.mas_equalTo(weakSelf.passwordView.mas_bottom);
    }];
    
    [_passwordAgainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(weakSelf.passwordView);
        make.top.mas_equalTo(weakSelf.passwordLineView.mas_bottom);
    }];
    
    [_passwordAgainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
        make.width.equalTo(weakSelf.passwordLab);
    }];
    
    [_passwordAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.passwordAgainLab.mas_right).offset(12.f);
    }];
    
    [_passwordAgainLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.topLineView);
        make.top.mas_equalTo(weakSelf.passwordAgainView.mas_bottom);
    }];
    
    [_confirmStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(weakSelf.passwordAgainView.mas_bottom).offset(32.f);
    }];
}

@end
