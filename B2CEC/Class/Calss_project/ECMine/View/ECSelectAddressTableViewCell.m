//
//  ECSelectAddressTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECSelectAddressTableViewCell.h"

@interface ECSelectAddressTableViewCell()

@property (strong,nonatomic) UIView *topView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UILabel *phoneLab;

@property (strong,nonatomic) UILabel *basicLab;

@property (strong,nonatomic) UILabel *addressLab;

@property (strong,nonatomic) UIButton *selectBtn;

@property (strong,nonatomic) ECAddressModel *model;

@property (strong,nonatomic) NSString *addressID;

@end

@implementation ECSelectAddressTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECSelectAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECSelectAddressTableViewCell)];
    if (cell == nil) {
        cell = [[ECSelectAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECSelectAddressTableViewCell)];
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
    
    if (!_basicLab) {
        _basicLab = [UILabel new];
    }
    _basicLab.text = @"默认";
    _basicLab.font = FONT_24;
    _basicLab.textAlignment = NSTextAlignmentCenter;
    _basicLab.textColor = [UIColor whiteColor];
    _basicLab.backgroundColor = DarkMoreColor;
    
    if (!_addressLab) {
        _addressLab = [UILabel new];
    }
    _addressLab.font = FONT_28;
    _addressLab.textColor = LightMoreColor;
    _addressLab.numberOfLines = 0;
    _addressLab.text = @"深圳市龙华新区民治街道牛栏前U创谷D11-31 曙华科技";
    
    if (!_selectBtn) {
        _selectBtn = [UIButton new];
    }
    [_selectBtn setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_selectBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.selectAddressBlock) {
            weakSelf.selectAddressBlock(weakSelf.model);
        }
    }];
    
    [self.contentView addSubview:_topView];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_phoneLab];
    [self.contentView addSubview:_basicLab];
    [self.contentView addSubview:_addressLab];
    [self.contentView addSubview:_selectBtn];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(4.f);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom).offset(16.f);
    }];
    
    [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameLab.mas_top);
        make.left.mas_equalTo(weakSelf.nameLab.mas_right).offset(20.f);
    }];
    
    [_basicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(36.f, 16.f));
        make.top.mas_equalTo(weakSelf.nameLab.mas_bottom).offset(12.f);
    }];
    
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.basicLab.mas_right).offset(12.f);
        make.right.mas_equalTo(weakSelf.selectBtn.mas_left).offset(-36.f);
        make.top.mas_equalTo(weakSelf.basicLab.mas_top);
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
        make.right.mas_equalTo(-16.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)setModel:(ECAddressModel *)model WithAddressID:(NSString *)addressID{
    self.model = model;
    self.addressID = addressID;
    WEAK_SELF
    
    _nameLab.text = model.consignee;
    _phoneLab.text = model.mobile_no;
    _addressLab.text = [NSString stringWithFormat:@"%@%@",model.area,model.address];
    if ([model.is_default isEqualToString:@"1"]) {
        [_basicLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.nameLab.mas_left);
            make.size.mas_equalTo(CGSizeMake(36.f, 16.f));
            make.top.mas_equalTo(weakSelf.nameLab.mas_bottom).offset(12.f);
        }];
        
        [_addressLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.basicLab.mas_right).offset(12.f);
            make.right.mas_equalTo(weakSelf.selectBtn.mas_left).offset(-36.f);
            make.top.mas_equalTo(weakSelf.nameLab.mas_bottom).offset(12.f);
        }];
    }else{
        [_basicLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0.f);
            make.size.mas_equalTo(CGSizeMake(0.f, 0.f));
        }];
        
        [_addressLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16.f);
            make.right.mas_equalTo(weakSelf.selectBtn.mas_left).offset(-36.f);
            make.top.mas_equalTo(weakSelf.nameLab.mas_bottom).offset(12.f);
        }];
    }
    [self.contentView layoutIfNeeded];
    
    //
    if (addressID == nil) {
        _selectBtn.selected = [model.is_default isEqualToString:@"1"];
    }else{
        _selectBtn.selected = [model.delivery_id isEqualToString:addressID];
    }
}

@end
