//
//  ECSettingPayPasswordTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECSettingPayPasswordTableViewCell.h"

@interface ECSettingPayPasswordTableViewCell()

@property (strong,nonatomic) UILabel *tipLab;

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

@implementation ECSettingPayPasswordTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECSettingPayPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECSettingPayPasswordTableViewCell)];
    if (cell == nil) {
        cell = [[ECSettingPayPasswordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECSettingPayPasswordTableViewCell)];
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
    
    if (!_tipLab) {
        _tipLab = [UILabel new];
    }
    _tipLab.text = @"请设置你的支付密码";
    _tipLab.textColor = DarkMoreColor;
    _tipLab.font = FONT_32;
    _tipLab.textAlignment = NSTextAlignmentCenter;
    
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
    _passwordLab.text = @"支付密码";
    _passwordLab.textColor = DarkMoreColor;
    _passwordLab.font = FONT_32;
    
    if (!_passwordTF) {
        _passwordTF = [UITextField new];
    }
    _passwordTF.placeholder = @"请输入6位有效数字";
    [_passwordTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _passwordTF.font = FONT_32;
    _passwordTF.textColor = DarkMoreColor;
    _passwordTF.keyboardType = UIKeyboardTypeDecimalPad;
    [_passwordTF handleControlEvent:UIControlEventValueChanged withBlock:^(UITextField *sender) {
        if (sender.text.length > 6) {
            weakSelf.passwordTF.text = [sender.text substringToIndex:6];
        }
    }];
    
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
    _passwordAgainLab.text = @"确认密码";
    _passwordAgainLab.textColor = DarkMoreColor;
    _passwordAgainLab.font = FONT_32;
    
    if (!_passwordAgainTF) {
        _passwordAgainTF = [UITextField new];
    }
    _passwordAgainTF.placeholder = @"再次输入您的支付密码";
    [_passwordAgainTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _passwordAgainTF.font = FONT_32;
    _passwordAgainTF.textColor = DarkMoreColor;
    _passwordAgainTF.keyboardType = UIKeyboardTypeDecimalPad;
    [_passwordAgainTF handleControlEvent:UIControlEventValueChanged withBlock:^(UITextField *sender) {
        if (sender.text.length > 6) {
            weakSelf.passwordAgainTF.text = [sender.text substringToIndex:6];
        }
    }];
    
    if (!_passwordAgainLineView) {
        _passwordAgainLineView = [UIView new];
    }
    _passwordAgainLineView.backgroundColor = LineDefaultsColor;
    
    if (!_confirmStepBtn) {
        _confirmStepBtn = [UIButton new];
    }
    [_confirmStepBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_confirmStepBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _confirmStepBtn.titleLabel.font = FONT_32;
    _confirmStepBtn.backgroundColor = [UIColor whiteColor];
    _confirmStepBtn.layer.borderColor = LineDefaultsColor.CGColor;
    _confirmStepBtn.layer.borderWidth = 0.5f;
    _confirmStepBtn.layer.cornerRadius = 5.f;
    _confirmStepBtn.layer.masksToBounds = YES;
    [_confirmStepBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (![CMPublicMethod isValidateNumber:weakSelf.passwordTF.text] || ![CMPublicMethod isValidateNumber:weakSelf.passwordAgainTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入6位有效数字"];
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
    
    [self.contentView addSubview:_tipLab];
    [self.contentView addSubview:_topView];
    [_topView addSubview:_topLineView];
    [_topView addSubview:_passwordView];
    [_passwordView addSubview:_passwordLab];
    [_passwordView addSubview:_passwordTF];
    [_topView addSubview:_passwordLineView];
    [_topView addSubview:_passwordAgainView];
    [_passwordAgainView addSubview:_passwordAgainLab];
    [_passwordAgainView addSubview:_passwordAgainTF];
    [_topView addSubview:_passwordAgainLineView];
    [self.contentView addSubview:_confirmStepBtn];
    
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(76.f);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.tipLab.mas_bottom);
        make.height.mas_equalTo(104.f);
    }];
    
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.topLineView.mas_bottom);
        make.height.mas_equalTo(52.f);
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
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
        make.top.mas_equalTo(0.f);
    }];
    
    [_passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.topLineView);
        make.centerY.mas_equalTo(weakSelf.topView.mas_centerY);
    }];
    
    [_passwordAgainLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.topLineView);
        make.bottom.mas_equalTo(0.f);
    }];
    
    [_confirmStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom).offset(28.f);
        make.height.mas_equalTo(49.f);
    }];
}

@end
