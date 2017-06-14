//
//  ECAddressManagementTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAddressManagementTableViewCell.h"

@interface ECAddressManagementTableViewCell()

@property (strong,nonatomic) UIView *topView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UILabel *phoneLab;

@property (strong,nonatomic) UILabel *addressLab;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIButton *basicBtn;

@property (strong,nonatomic) UILabel *basicLab;

@property (strong,nonatomic) UIButton *editBtn;

@property (strong,nonatomic) UIButton *deleteBtn;

@end

@implementation ECAddressManagementTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECAddressManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddressManagementTableViewCell)];
    if (cell == nil) {
        cell = [[ECAddressManagementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddressManagementTableViewCell)];
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
    
    if (!_topView) {
        _topView = [UIView new];
    }
    _topView.backgroundColor = BaseColor;
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.font = FONT_32;
    _nameLab.textColor = DarkMoreColor;
    _nameLab.text = @"小白龙";
    
    if (!_phoneLab) {
        _phoneLab = [UILabel new];
    }
    _phoneLab.font = FONT_32;
    _phoneLab.textColor = DarkMoreColor;
    _phoneLab.text = @"13856558985";
    
    if (!_addressLab) {
        _addressLab = [UILabel new];
    }
    _addressLab.font = [UIFont systemFontOfSize:15.f];
    _addressLab.textColor = DarkMoreColor;
    _addressLab.numberOfLines = 0;
    _addressLab.text = @"深圳市龙华新区民治街道牛栏前U创谷D11-31 曙华科技";
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    if (!_basicBtn) {
        _basicBtn = [UIButton new];
    }
    [_basicBtn setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
    [_basicBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_basicBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if ([weakSelf.model.is_default isEqualToString:@"1"]) {
            [SVProgressHUD showInfoWithStatus:@"当前地址已是默认收货地址"];
            return ;
        }
        if (weakSelf.defaultAdressClickBlock) {
            weakSelf.defaultAdressClickBlock(weakSelf.model);
        }
    }];
    
    if (!_basicLab) {
        _basicLab = [UILabel new];
    }
    _basicLab.text = @"[设为默认地址]";
    _basicLab.font = FONT_28;
    _basicLab.textColor = LightColor;
    
    if (!_editBtn) {
        _editBtn = [UIButton new];
    }
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    _editBtn.layer.borderColor = LineDefaultsColor.CGColor;
    _editBtn.layer.borderWidth = 1.f;
    [_editBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.editAdressClickBlock) {
            weakSelf.editAdressClickBlock(weakSelf.model);
        }
    }];
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
    }
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    _deleteBtn.layer.borderColor = LineDefaultsColor.CGColor;
    _deleteBtn.layer.borderWidth = 1.f;
    [_deleteBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.deleteAdressClickBlock) {
            weakSelf.deleteAdressClickBlock(weakSelf.model);
        }
    }];
    
    [self.contentView addSubview:_topView];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_phoneLab];
    [self.contentView addSubview:_addressLab];
    [self.contentView addSubview:_lineView];
    [self.contentView addSubview:_basicBtn];
    [self.contentView addSubview:_basicLab];
    [self.contentView addSubview:_editBtn];
    [self.contentView addSubview:_deleteBtn];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(8.f);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom).offset(12.f);
    }];
    
    [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameLab.mas_top);
        make.left.mas_equalTo(weakSelf.nameLab.mas_right).offset(12.f);
    }];
    
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.nameLab.mas_bottom).offset(12.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.bottom.mas_equalTo(-44.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_basicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
        make.bottom.mas_equalTo(-11.f);
        make.left.mas_equalTo(12.f);
    }];
    
    [_basicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.basicBtn.mas_right).offset(6.f);
        make.centerY.mas_equalTo(weakSelf.basicBtn.mas_centerY);
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54.f, 28.f));
        make.centerY.mas_equalTo(weakSelf.basicBtn.mas_centerY);
        make.right.mas_equalTo(weakSelf.deleteBtn.mas_left).offset(-6.f);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(weakSelf.editBtn);
        make.right.mas_equalTo(-12.f);
    }];
}

- (void)setModel:(ECAddressModel *)model{
    _model = model;
    _nameLab.text = model.consignee;
    _phoneLab.text = model.mobile_no;
    _addressLab.text = [NSString stringWithFormat:@"%@%@",model.area,model.address];
    _basicBtn.selected = [model.is_default isEqualToString:@"1"];
}

@end
