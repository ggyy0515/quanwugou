//
//  ECAccountResetPhoneTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAccountResetPhoneTableViewCell.h"

@interface ECAccountResetPhoneTableViewCell()

@property (strong,nonatomic) UILabel *tipsLab;

@property (strong,nonatomic) UIView *inputView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UITextField *nameTF;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIButton *getVerficationBtn;

@property (strong,nonatomic) UIView *lineview1;

@property (strong,nonatomic) UIView *lineview2;

@property (strong,nonatomic) UIButton *submitBtn;

@end

@implementation ECAccountResetPhoneTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECAccountResetPhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAccountResetPhoneTableViewCell)];
    if (cell == nil) {
        cell = [[ECAccountResetPhoneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAccountResetPhoneTableViewCell)];
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
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.font = FONT_32;
    _nameLab.textColor = DarkMoreColor;
    _nameLab.text = @"校验码";
    
    if (!_nameTF) {
        _nameTF = [UITextField new];
    }
    [_nameTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _nameTF.textColor = DarkMoreColor;
    _nameTF.font = FONT_32;
    _nameTF.keyboardType = UIKeyboardTypeDecimalPad;
    _nameTF.placeholder = @"请输入收到的校验码";
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    if (!_getVerficationBtn) {
        _getVerficationBtn = [UIButton new];
    }
    [_getVerficationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerficationBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _getVerficationBtn.titleLabel.font = FONT_32;
    [weakSelf countDown];
    [_getVerficationBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.getVerficationBlock) {
            weakSelf.getVerficationBlock();
        }
        weakSelf.nameTF.text = @"";
        [weakSelf countDown];
    }];
    
    if (!_lineview1) {
        _lineview1 = [UIView new];
    }
    _lineview1.backgroundColor = LineDefaultsColor;
    
    if (!_lineview2) {
        _lineview2 = [UIView new];
    }
    _lineview2.backgroundColor = LineDefaultsColor;
    
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
    }
    [_submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = FONT_32;
    _submitBtn.backgroundColor = [UIColor whiteColor];
    _submitBtn.layer.borderColor = LineDefaultsColor.CGColor;
    _submitBtn.layer.borderWidth = 0.5f;
    _submitBtn.layer.cornerRadius = 5.f;
    _submitBtn.layer.masksToBounds = YES;
    [_submitBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.contentView endEditing:YES];
        if (weakSelf.nameTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入收到的校验码"];
            return ;
        }
        if (weakSelf.nextStepBlock) {
            weakSelf.nextStepBlock(weakSelf.nameTF.text);
        }
    }];
    
    [self.contentView addSubview:_tipsLab];
    [self.contentView addSubview:_inputView];
    [_inputView addSubview:_nameLab];
    [_inputView addSubview:_nameTF];
    [_inputView addSubview:_lineView];
    [_inputView addSubview:_getVerficationBtn];
    [_inputView addSubview:_lineview1];
    [_inputView addSubview:_lineview2];
    [self.contentView addSubview:_submitBtn];
    
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(76.f);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.tipsLab.mas_bottom);
        make.height.mas_equalTo(52.f);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
    }];
    
    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.lineView.mas_left).offset(-12.f);
        make.left.mas_equalTo(weakSelf.nameLab.mas_right).mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.inputView.mas_centerY);
        make.right.mas_equalTo(weakSelf.getVerficationBtn.mas_left);
        make.height.mas_equalTo(32.f);
        make.width.mas_equalTo(0.5f);
    }];
    
    [_getVerficationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(-12.f);
        make.width.mas_equalTo(100.f);
    }];
    
    [_lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_lineview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.lineview1);
        make.bottom.mas_equalTo(0.f);
    }];
    
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.inputView.mas_bottom).offset(28.f);
        make.height.mas_equalTo(49.f);
    }];    
}

- (void)countDown{
    [CMPublicMethod countDownWithTime:60 WithOperation:^(NSInteger count) {
        [self.getVerficationBtn setTitle:[NSString stringWithFormat:@"%ldS",(long)count] forState:UIControlStateNormal];
        [self.getVerficationBtn setTitleColor:LightColor forState:UIControlStateNormal];
        self.getVerficationBtn.enabled = NO;
    } WithCompletion:^{
        [self.getVerficationBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.getVerficationBtn setTitleColor:MainColor forState:UIControlStateNormal];
        self.getVerficationBtn.enabled = YES;
    }];
}

- (void)setTips:(NSString *)tips{
    _tips = tips;
    _tipsLab.text = tips;
}

- (void)setSubmitStr:(NSString *)submitStr{
    _submitStr = submitStr;
    [_submitBtn setTitle:submitStr forState:UIControlStateNormal];
}

@end
