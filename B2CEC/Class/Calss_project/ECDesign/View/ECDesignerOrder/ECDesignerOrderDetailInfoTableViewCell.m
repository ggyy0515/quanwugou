//
//  ECDesignerOrderDetailInfoTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderDetailInfoTableViewCell.h"

@interface ECDesignerOrderDetailInfoTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *areaNameLab;

@property (strong,nonatomic) UILabel *areaDataLab;

@property (strong,nonatomic) UILabel *typeNameLab;

@property (strong,nonatomic) UILabel *typeDataLab;

@property (strong,nonatomic) UILabel *houseNameLab;

@property (strong,nonatomic) UILabel *houseDataLab;

@property (strong,nonatomic) UILabel *styleNameLab;

@property (strong,nonatomic) UILabel *styleDataLab;

@property (strong,nonatomic) UILabel *cycleNameLab;

@property (strong,nonatomic) UILabel *cycleDataLab;

@end

@implementation ECDesignerOrderDetailInfoTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerOrderDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderDetailInfoTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerOrderDetailInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderDetailInfoTableViewCell)];
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
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"详细信息";
    _titleLab.textColor = DarkMoreColor;
    _titleLab.font = FONT_B_32;
    
    if (!_areaNameLab) {
        _areaNameLab = [UILabel new];
    }
    _areaNameLab.text = @"面积:";
    _areaNameLab.textColor = LightMoreColor;
    _areaNameLab.font = FONT_32;
    
    if (!_areaDataLab) {
        _areaDataLab = [UILabel new];
    }
    _areaDataLab.textColor = LightMoreColor;
    _areaDataLab.font = FONT_32;
    
    if (!_typeNameLab) {
        _typeNameLab = [UILabel new];
    }
    _typeNameLab.text = @"户型:";
    _typeNameLab.textColor = LightMoreColor;
    _typeNameLab.font = FONT_32;
    
    if (!_typeDataLab) {
        _typeDataLab = [UILabel new];
    }
    _typeDataLab.textColor = LightMoreColor;
    _typeDataLab.font = FONT_32;
    
    if (!_houseNameLab) {
        _houseNameLab = [UILabel new];
    }
    _houseNameLab.text = @"房屋类型:";
    _houseNameLab.textColor = LightMoreColor;
    _houseNameLab.font = FONT_32;
    
    if (!_houseDataLab) {
        _houseDataLab = [UILabel new];
    }
    _houseDataLab.textColor = LightMoreColor;
    _houseDataLab.font = FONT_32;
    
    if (!_styleNameLab) {
        _styleNameLab = [UILabel new];
    }
    _styleNameLab.text = @"设计风格:";
    _styleNameLab.textColor = LightMoreColor;
    _styleNameLab.font = FONT_32;
    
    if (!_styleDataLab) {
        _styleDataLab = [UILabel new];
    }
    _styleDataLab.textColor = LightMoreColor;
    _styleDataLab.font = FONT_32;
    
    if (!_cycleNameLab) {
        _cycleNameLab = [UILabel new];
    }
    _cycleNameLab.text = @"预计天数:";
    _cycleNameLab.textColor = LightMoreColor;
    _cycleNameLab.font = FONT_32;
    
    if (!_cycleDataLab) {
        _cycleDataLab = [UILabel new];
    }
    _cycleDataLab.textColor = LightMoreColor;
    _cycleDataLab.font = FONT_32;
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_areaNameLab];
    [self.contentView addSubview:_areaDataLab];
    [self.contentView addSubview:_typeNameLab];
    [self.contentView addSubview:_typeDataLab];
    [self.contentView addSubview:_houseNameLab];
    [self.contentView addSubview:_houseDataLab];
    [self.contentView addSubview:_styleNameLab];
    [self.contentView addSubview:_styleDataLab];
    [self.contentView addSubview:_cycleNameLab];
    [self.contentView addSubview:_cycleDataLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12.f);
    }];
    
    [_areaNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLab.mas_left);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom).offset(27.f);
        make.width.mas_equalTo(80.f);
    }];
    
    [_areaDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.areaNameLab.mas_right);
        make.centerY.mas_equalTo(weakSelf.areaNameLab.mas_centerY);
    }];
    
    [_typeNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(weakSelf.areaNameLab);
        make.top.mas_equalTo(weakSelf.areaNameLab.mas_bottom).offset(30.f);
    }];
    
    [_typeDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.areaDataLab.mas_left);
        make.centerY.mas_equalTo(weakSelf.typeNameLab.mas_centerY);
    }];
    
    [_houseNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(weakSelf.areaNameLab);
        make.top.mas_equalTo(weakSelf.typeNameLab.mas_bottom).offset(30.f);
    }];
    
    [_houseDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.areaDataLab.mas_left);
        make.centerY.mas_equalTo(weakSelf.houseNameLab.mas_centerY);
    }];
    
    [_styleNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(weakSelf.areaNameLab);
        make.top.mas_equalTo(weakSelf.houseNameLab.mas_bottom).offset(30.f);
    }];
    
    [_styleDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.areaDataLab.mas_left);
        make.centerY.mas_equalTo(weakSelf.styleNameLab.mas_centerY);
    }];
    
    [_cycleNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(weakSelf.areaNameLab);
        make.top.mas_equalTo(weakSelf.styleNameLab.mas_bottom).offset(30.f);
    }];
    
    [_cycleDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.areaDataLab.mas_left);
        make.centerY.mas_equalTo(weakSelf.cycleNameLab.mas_centerY);
    }];
}

- (void)setModel:(ECDesignerOrderDetailModel *)model{
    _model = model;
    _areaDataLab.text = [NSString stringWithFormat:@"%@平米",model.housearea];
    _typeDataLab.text = model.decoratetype;
    _houseDataLab.text = model.housetype;
    _styleDataLab.text = model.style;
    _cycleDataLab.text = [NSString stringWithFormat:@"%@天",model.cycle];
}

@end
