//
//  ECAddAddressTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAddAddressTableViewCell.h"

@interface ECAddAddressTableViewCell()

@property (strong,nonatomic) UIView *inputView;

@property (strong,nonatomic) UITextField *nameTF;

@property (strong,nonatomic) UIView *nameLineView;

@property (strong,nonatomic) UITextField *phoneTF;

@property (strong,nonatomic) UIView *phoneLineView;

@property (strong,nonatomic) UILabel *addressNameLab;

@property (strong,nonatomic) UILabel *addressDataLab;

@property (strong,nonatomic) UIImageView *addressDirImageView;

@property (strong,nonatomic) UIButton *addressBtn;

@property (strong,nonatomic) UIView *addressLineView;

@property (strong,nonatomic) UITextField *addressDetailTF;

@property (strong,nonatomic) UIView *addressDetailLineView;

@property (strong,nonatomic) UILabel *defaultsLab;

@property (strong,nonatomic) UISwitch *defaultsSwitch;

@property (strong,nonatomic) UIButton *saveBtn;

@end

@implementation ECAddAddressTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECAddAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddAddressTableViewCell)];
    if (cell == nil) {
        cell = [[ECAddAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddAddressTableViewCell)];
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
    
    if (!_inputView) {
        _inputView = [UIView new];
    }
    _inputView.backgroundColor = [UIColor whiteColor];
    
    if (!_nameTF) {
        _nameTF = [UITextField new];
    }
    _nameTF.placeholder = @"收货人姓名";
    [_nameTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _nameTF.textColor = DarkMoreColor;
    _nameTF.font = FONT_32;
    
    if (!_nameLineView) {
        _nameLineView = [UIView new];
    }
    _nameLineView.backgroundColor = LineDefaultsColor;
    
    if (!_phoneTF) {
        _phoneTF = [UITextField new];
    }
    _phoneTF.placeholder = @"手机号";
    [_phoneTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _phoneTF.textColor = DarkMoreColor;
    _phoneTF.font = FONT_32;
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    
    if (!_phoneLineView) {
        _phoneLineView = [UIView new];
    }
    _phoneLineView.backgroundColor = LineDefaultsColor;
    
    if (!_addressNameLab) {
        _addressNameLab = [UILabel new];
    }
    _addressNameLab.text = @"所在地区";
    _addressNameLab.font = FONT_32;
    _addressNameLab.textColor = DarkMoreColor;
    
    if (!_addressDataLab) {
        _addressDataLab = [UILabel new];
    }
    _addressDataLab.textColor = DarkMoreColor;
    _addressDataLab.font = FONT_32;
    _addressDataLab.textAlignment = NSTextAlignmentRight;
    
    if (!_addressDirImageView) {
        _addressDirImageView = [UIImageView new];
    }
    _addressDirImageView.image = [UIImage imageNamed:@"enter"];
    
    if (!_addressBtn) {
        _addressBtn = [UIButton new];
    }
    [_addressBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.selectCityBlock) {
            weakSelf.selectCityBlock();
        }
    }];
    
    if (!_addressLineView) {
        _addressLineView = [UIView new];
    }
    _addressLineView.backgroundColor = LineDefaultsColor;

    if (!_addressDetailTF) {
        _addressDetailTF = [UITextField new];
    }
    _addressDetailTF.placeholder = @"详细地址";
    [_addressDetailTF setValue:LightPlaceholderColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _addressDetailTF.textColor = DarkMoreColor;
    _addressDetailTF.font = FONT_32;
    
    if (!_addressDetailLineView) {
        _addressDetailLineView = [UIView new];
    }
    _addressDetailLineView.backgroundColor = LineDefaultsColor;
    
    if (!_defaultsLab) {
        _defaultsLab = [UILabel new];
    }
    _defaultsLab.text = @"设为默认";
    _defaultsLab.font = FONT_32;
    _defaultsLab.textColor = DarkMoreColor;
    
    if (!_defaultsSwitch) {
        _defaultsSwitch = [UISwitch new];
    }
    _defaultsSwitch.tintColor = BaseColor;
    _defaultsSwitch.onTintColor = DarkMoreColor;
    _defaultsSwitch.on = YES;
    
    if (!_saveBtn) {
        _saveBtn = [UIButton new];
    }
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.backgroundColor = DarkMoreColor;
    _saveBtn.titleLabel.font = FONT_32;
    _saveBtn.layer.cornerRadius = 5.f;
    _saveBtn.layer.masksToBounds = YES;
    [_saveBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.contentView endEditing:YES];
        if (weakSelf.nameTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入收货人姓名"];
            return ;
        }
        if (![WJRegularVerify phoneNumberVerify:weakSelf.phoneTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
            return ;
        }
        if (weakSelf.address == nil) {
            [SVProgressHUD showErrorWithStatus:@"请选择所在地区"];
            return ;
        }
        if (weakSelf.addressDetailTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入详细地址"];
            return ;
        }
        if (weakSelf.saveAddressBlock) {
            weakSelf.saveAddressBlock(weakSelf.nameTF.text,weakSelf.phoneTF.text,weakSelf.addressDataLab.text,weakSelf.addressDetailTF.text,weakSelf.defaultsSwitch.on);
        }
    }];
    
    [self.contentView addSubview:_inputView];
    [_inputView addSubview:_nameTF];
    [_inputView addSubview:_phoneTF];
    [_inputView addSubview:_addressNameLab];
    [_inputView addSubview:_addressDataLab];
    [_inputView addSubview:_addressDirImageView];
    [_inputView addSubview:_addressBtn];
    [_inputView addSubview:_addressDetailTF];
    [_inputView addSubview:_nameLineView];
    [_inputView addSubview:_phoneLineView];
    [_inputView addSubview:_addressLineView];
    [_inputView addSubview:_addressDetailLineView];
    [_inputView addSubview:_defaultsLab];
    [_inputView addSubview:_defaultsSwitch];
    [self.contentView addSubview:_saveBtn];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(49.f * 5.f);
    }];
    
    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(49.f);
    }];
    
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameTF);
        make.top.mas_equalTo(weakSelf.nameTF.mas_bottom);
    }];
    
    [_addressNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(weakSelf.nameTF);
        make.top.mas_equalTo(weakSelf.phoneTF.mas_bottom);
    }];
    
    [_addressDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.addressNameLab);
        make.right.mas_equalTo(weakSelf.addressDirImageView.mas_left).offset(-8.f);
    }];
    
    [_addressDirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.addressNameLab.mas_centerY);
    }];
    
    [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameTF);
        make.top.mas_equalTo(weakSelf.phoneTF.mas_bottom);
    }];
    
    [_addressDetailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameTF);
        make.top.mas_equalTo(weakSelf.addressNameLab.mas_bottom);
    }];
    
    [_defaultsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(weakSelf.nameTF);
        make.top.mas_equalTo(weakSelf.addressDetailTF.mas_bottom);
    }];
    
    [_defaultsSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.nameTF);
        make.size.mas_equalTo(CGSizeMake(80.f, 30.f));
        make.centerY.mas_equalTo(weakSelf.defaultsLab.mas_centerY);
    }];
    
    [_nameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
        make.bottom.mas_equalTo(weakSelf.nameTF.mas_bottom);
    }];
    
    [_phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameLineView);
        make.bottom.mas_equalTo(weakSelf.phoneTF.mas_bottom);
    }];
    
    [_addressLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameLineView);
        make.bottom.mas_equalTo(weakSelf.addressNameLab.mas_bottom);
    }];
    
    [_addressDetailLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameLineView);
        make.bottom.mas_equalTo(weakSelf.addressDetailTF.mas_bottom);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameTF);
        make.top.mas_equalTo(weakSelf.inputView.mas_bottom).offset(18.f);
    }];
}

- (void)setAddress:(NSString *)address{
    _address = address;
    _addressDataLab.text = address;
}

- (void)setModel:(ECAddressModel *)model{
    _model = model;
    //如果是修改地址，则无法修改是否默认
    _defaultsLab.hidden = YES;
    _defaultsSwitch.hidden = YES;
    _addressDetailLineView.hidden = YES;
    [_inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(49.f * 4.f);
    }];
    
    [self.contentView layoutIfNeeded];
    
    _nameTF.text = model.consignee;
    _phoneTF.text = model.mobile_no;
    self.address = model.area;
    _addressDetailTF.text = model.address;
    _defaultsSwitch.on = [model.is_default isEqualToString:@"1"];
}

@end
