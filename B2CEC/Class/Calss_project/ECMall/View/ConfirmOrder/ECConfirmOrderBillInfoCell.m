//
//  ECConfirmOrderBillInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECConfirmOrderBillInfoCell.h"

@interface ECConfirmOrderBillInfoCell ()
<
    UITextFieldDelegate
>

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *swh;
@property (nonatomic, strong) UIButton *personBtn;
@property (nonatomic, strong) UIButton *comBtn;
@property (nonatomic, strong) UITextField *infoTF;

@end

@implementation ECConfirmOrderBillInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_swh) {
        _swh = [UISwitch new];
    }
    [self.contentView addSubview:_swh];
    _swh.tintColor = BaseColor;
    _swh.onTintColor = DarkMoreColor;
    _swh.on = NO;
    [_swh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 30.f));
        make.top.mas_equalTo(weakSelf.mas_top).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
    }];
    _swh.on = NO;
    [_swh addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_32;
    _titleLabel.textColor = DarkMoreColor;
    _titleLabel.text = @"是否需要发票";
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.swh.mas_centerY);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.right.mas_equalTo(weakSelf.swh.mas_left).offset(-12.f);
        make.height.mas_equalTo(weakSelf.titleLabel.font.lineHeight);
    }];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = UIColorFromHexString(@"#dddddd");
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(weakSelf.swh.mas_bottom).offset(12.f);
    }];
    
    if (!_personBtn) {
        _personBtn = [UIButton new];
    }
    [self.contentView addSubview:_personBtn];
    [_personBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_personBtn setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
    [_personBtn setTitle:@"个人" forState:UIControlStateNormal];
    [_personBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _personBtn.titleLabel.font = FONT_32;
    [_personBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12.f, 0, -12.f)];
    [_personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.top.mas_equalTo(weakSelf.line.mas_bottom).offset(25.f);
        make.size.mas_equalTo(CGSizeMake(80.f, 20.f));
    }];
    _personBtn.hidden = YES;
    [_personBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        sender.selected = YES;
        weakSelf.comBtn.selected = NO;
    }];
    
    if (!_comBtn) {
        _comBtn = [UIButton new];
    }
    [self.contentView addSubview:_comBtn];
    [_comBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_comBtn setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
    [_comBtn setTitle:@"公司" forState:UIControlStateNormal];
    [_comBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _comBtn.titleLabel.font = FONT_32;
    [_comBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12.f, 0, -12.f)];
    [_comBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.personBtn.mas_right).offset(60.f);
        make.centerY.mas_equalTo(weakSelf.personBtn.mas_centerY);
        make.size.mas_equalTo(weakSelf.personBtn);
    }];
    _comBtn.hidden = YES;
    [_comBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        sender.selected = YES;
        weakSelf.personBtn.selected = NO;
    }];
    
    if (!_infoTF) {
        _infoTF = [UITextField new];
    }
    [self.contentView addSubview:_infoTF];
    _infoTF.textColor = DarkColor;
    [_infoTF setBorderStyle:UITextBorderStyleNone];
    [_infoTF setValue:UIColorFromHexString(@"#cccccc") forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _infoTF.placeholder = @"填写内容";
    _infoTF.delegate = self;
    [_infoTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.top.mas_equalTo(weakSelf.personBtn.mas_bottom).offset(30.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.height.mas_equalTo(30.f);
    }];
    _infoTF.hidden = YES;
}

- (void)switchValueChanged:(UISwitch *)sender {
    _personBtn.hidden = _comBtn.hidden = _infoTF.hidden = !sender.isOn;
    if (_billSateChanged) {
        _billSateChanged(sender.isOn);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_didInputBillInfo) {
        _didInputBillInfo(textField.text);
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_didInputBillInfo) {
        _didInputBillInfo(textField.text);
    }
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
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
