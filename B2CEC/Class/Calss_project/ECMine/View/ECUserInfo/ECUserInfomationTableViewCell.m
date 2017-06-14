//
//  ECUserInfomationTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/6.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfomationTableViewCell.h"

@interface ECUserInfomationTableViewCell()

@property (strong,nonatomic) UILabel *nameNameLab;

@property (strong,nonatomic) UILabel *nameDataLab;

@property (strong,nonatomic) UIView *nameLineView;

@property (strong,nonatomic) UILabel *sexNameLab;

@property (strong,nonatomic) UILabel *sexDataLab;

@property (strong,nonatomic) UIView *sexLineView;

@property (strong,nonatomic) UILabel *ageNameLab;

@property (strong,nonatomic) UILabel *ageDataLab;

@property (strong,nonatomic) UIView *ageLineView;

@property (strong,nonatomic) UILabel *addressNameLab;

@property (strong,nonatomic) UILabel *addressDataLab;

@property (strong,nonatomic) UIView *addressLineView;

@property (strong,nonatomic) UILabel *styleNameLab;

@property (strong,nonatomic) UILabel *styleDataLab;

@property (strong,nonatomic) UIView *styleLineView;

@property (strong,nonatomic) UILabel *chargeNameLab;

@property (strong,nonatomic) UILabel *chargeDataLab;

@property (strong,nonatomic) UIView *chargeLineView;

@property (strong,nonatomic) UILabel *expressNameLab;

@property (strong,nonatomic) UILabel *expressDataLab;

@property (strong,nonatomic) UIView *expressLineView;

@property (strong,nonatomic) UIImageView *iconImageView;

@end

@implementation ECUserInfomationTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECUserInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfomationTableViewCell)];
    if (cell == nil) {
        cell = [[ECUserInfomationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfomationTableViewCell)];
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
    if (!_nameNameLab) {
        _nameNameLab = [UILabel new];
    }
    _nameNameLab.text = @"姓名";
    _nameNameLab.textColor = LightColor;
    _nameNameLab.font = FONT_32;
    
    if (!_nameDataLab) {
        _nameDataLab = [UILabel new];
    }
    _nameDataLab.text = @"于继苟";
    _nameDataLab.textColor = DarkMoreColor;
    _nameDataLab.font = FONT_32;
    
    if (!_nameLineView) {
        _nameLineView = [UIView new];
    }
    _nameLineView.backgroundColor = LineDefaultsColor;
    
    if (!_sexNameLab) {
        _sexNameLab = [UILabel new];
    }
    _sexNameLab.text = @"性别";
    _sexNameLab.textColor = LightColor;
    _sexNameLab.font = FONT_32;
    
    if (!_sexDataLab) {
        _sexDataLab = [UILabel new];
    }
    _sexDataLab.text = @"男";
    _sexDataLab.textColor = DarkMoreColor;
    _sexDataLab.font = FONT_32;
    
    if (!_sexLineView) {
        _sexLineView = [UIView new];
    }
    _sexLineView.backgroundColor = LineDefaultsColor;
    
    if (!_ageNameLab) {
        _ageNameLab = [UILabel new];
    }
    _ageNameLab.text = @"年龄";
    _ageNameLab.textColor = LightColor;
    _ageNameLab.font = FONT_32;
    
    if (!_ageDataLab) {
        _ageDataLab = [UILabel new];
    }
    _ageDataLab.text = @"18";
    _ageDataLab.textColor = DarkMoreColor;
    _ageDataLab.font = FONT_32;
    
    if (!_ageLineView) {
        _ageLineView = [UIView new];
    }
    _ageLineView.backgroundColor = LineDefaultsColor;
    
    if (!_addressNameLab) {
        _addressNameLab = [UILabel new];
    }
    _addressNameLab.text = @"现居";
    _addressNameLab.textColor = LightColor;
    _addressNameLab.font = FONT_32;
    
    if (!_addressDataLab) {
        _addressDataLab = [UILabel new];
    }
    _addressDataLab.text = @"广东省深圳市";
    _addressDataLab.textColor = DarkMoreColor;
    _addressDataLab.font = FONT_32;
    
    if (!_addressLineView) {
        _addressLineView = [UIView new];
    }
    _addressLineView.backgroundColor = LineDefaultsColor;
    
    if (!_styleNameLab) {
        _styleNameLab = [UILabel new];
    }
    _styleNameLab.text = @"风格";
    _styleNameLab.textColor = LightColor;
    _styleNameLab.font = FONT_32;
    
    if (!_styleDataLab) {
        _styleDataLab = [UILabel new];
    }
    _styleDataLab.text = @"";
    _styleDataLab.textColor = DarkMoreColor;
    _styleDataLab.font = FONT_32;
    
    if (!_styleLineView) {
        _styleLineView = [UIView new];
    }
    _styleLineView.backgroundColor = LineDefaultsColor;
    
    if (!_chargeNameLab) {
        _chargeNameLab = [UILabel new];
    }
    _chargeNameLab.text = @"报价";
    _chargeNameLab.textColor = LightColor;
    _chargeNameLab.font = FONT_32;
    
    if (!_chargeDataLab) {
        _chargeDataLab = [UILabel new];
    }
    _chargeDataLab.text = @"￥100/m²";
    _chargeDataLab.textColor = DarkMoreColor;
    _chargeDataLab.font = FONT_32;
    
    if (!_chargeLineView) {
        _chargeLineView = [UIView new];
    }
    _chargeLineView.backgroundColor = LineDefaultsColor;
    
    if (!_expressNameLab) {
        _expressNameLab = [UILabel new];
    }
    _expressNameLab.text = @"从业经验";
    _expressNameLab.textColor = LightColor;
    _expressNameLab.font = FONT_32;
    
    if (!_expressDataLab) {
        _expressDataLab = [UILabel new];
    }
    _expressDataLab.text = @"10年";
    _expressDataLab.textColor = DarkMoreColor;
    _expressDataLab.font = FONT_32;
    
    if (!_expressLineView) {
        _expressLineView = [UIView new];
    }
    _expressLineView.backgroundColor = LineDefaultsColor;
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"placeholder_goods2"];
    
    [self.contentView addSubview:_nameNameLab];
    [self.contentView addSubview:_nameDataLab];
    [self.contentView addSubview:_nameLineView];
    [self.contentView addSubview:_sexNameLab];
    [self.contentView addSubview:_sexDataLab];
    [self.contentView addSubview:_sexLineView];
    [self.contentView addSubview:_ageNameLab];
    [self.contentView addSubview:_ageDataLab];
    [self.contentView addSubview:_ageLineView];
    [self.contentView addSubview:_addressNameLab];
    [self.contentView addSubview:_addressDataLab];
    [self.contentView addSubview:_addressLineView];
    [self.contentView addSubview:_styleNameLab];
    [self.contentView addSubview:_styleDataLab];
    [self.contentView addSubview:_styleLineView];
    [self.contentView addSubview:_chargeNameLab];
    [self.contentView addSubview:_chargeDataLab];
    [self.contentView addSubview:_chargeLineView];
    [self.contentView addSubview:_expressNameLab];
    [self.contentView addSubview:_expressDataLab];
    [self.contentView addSubview:_expressLineView];
    [self.contentView addSubview:_iconImageView];
}

- (void)setModel:(ECUserInfoModel *)model{
    _model = model;
    _nameDataLab.text = model.designerinfo.name;
    _sexDataLab.text = model.designerinfo.sex;
    _ageDataLab.text = [NSString stringWithFormat:@"%ld",[CMPublicMethod getAgeWithBirth:model.designerinfo.birth]];
    _addressDataLab.text = [NSString stringWithFormat:@"%@%@",model.designerinfo.province,model.designerinfo.city];
    _styleDataLab.text = model.designerinfo.style;
    _chargeDataLab.text = [NSString stringWithFormat:@"￥%@/m²",model.designerinfo.charge];
    _expressDataLab.text = [NSString stringWithFormat:@"%@年",model.designerinfo.obtainyears];
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.designerinfo.desigerHeadImg)] placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
    
    WEAK_SELF
    
    [_nameNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5.f);
        make.left.mas_equalTo(12.f);
        make.height.mas_equalTo(44.f);
        make.width.mas_equalTo([CMPublicMethod getWidthWithLabel:weakSelf.nameNameLab]);
    }];
    
    [_nameDataLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.iconImageView.mas_left).offset(-28.f);
        make.left.mas_equalTo(weakSelf.nameNameLab.mas_right).offset(28.f);
        make.top.bottom.equalTo(weakSelf.nameNameLab);
    }];
    
    [_nameLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameNameLab.mas_left);
        make.right.mas_equalTo(weakSelf.nameDataLab.mas_right);
        make.bottom.mas_equalTo(weakSelf.nameNameLab.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_sexNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameNameLab);
        make.top.mas_equalTo(weakSelf.nameNameLab.mas_bottom);
    }];
    
    [_sexDataLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.nameDataLab);
        make.top.bottom.equalTo(weakSelf.sexNameLab);
    }];
    
    [_sexLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameLineView);
        make.bottom.mas_equalTo(weakSelf.sexNameLab.mas_bottom);
    }];
    
    [_ageNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameNameLab);
        make.top.mas_equalTo(weakSelf.sexNameLab.mas_bottom);
    }];
    
    [_ageDataLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.nameDataLab);
        make.top.bottom.equalTo(weakSelf.ageNameLab);
    }];
    
    [_ageLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameLineView);
        make.bottom.mas_equalTo(weakSelf.ageNameLab.mas_bottom);
    }];
    
    [_addressNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameNameLab);
        make.top.mas_equalTo(weakSelf.ageNameLab.mas_bottom);
    }];
    
    [_addressDataLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.nameDataLab);
        make.top.bottom.equalTo(weakSelf.addressNameLab);
    }];
    
    [_addressLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameLineView);
        make.bottom.mas_equalTo(weakSelf.addressNameLab.mas_bottom);
    }];
    
    [_styleNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameNameLab);
        make.top.mas_equalTo(weakSelf.addressNameLab.mas_bottom);
    }];
    
    [_styleDataLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.nameDataLab);
        make.top.bottom.equalTo(weakSelf.styleNameLab);
    }];
    
    [_styleLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameLineView);
        make.bottom.mas_equalTo(weakSelf.styleNameLab.mas_bottom);
    }];
    
    [_chargeNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.nameNameLab);
        make.top.mas_equalTo(weakSelf.styleNameLab.mas_bottom);
    }];
    
    [_chargeDataLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.chargeNameLab.mas_right).offset(28.f);
        make.right.mas_equalTo(weakSelf.chargeLineView.mas_right);
        make.top.bottom.equalTo(weakSelf.chargeNameLab);
    }];
    
    [_chargeLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(weakSelf.nameLineView);
        make.right.mas_equalTo(weakSelf.expressLineView.mas_left).offset(-13.f);
        make.bottom.mas_equalTo(weakSelf.chargeNameLab.mas_bottom);
        make.width.mas_equalTo(weakSelf.expressLineView.mas_width);
    }];
    
    [_expressNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.expressLineView.mas_left);
        make.top.height.equalTo(weakSelf.chargeNameLab);
        make.width.mas_equalTo([CMPublicMethod getWidthWithLabel:weakSelf.expressNameLab]);
    }];
    
    [_expressDataLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.expressNameLab.mas_right).offset(28.f);
        make.right.mas_equalTo(weakSelf.expressLineView.mas_right);
        make.top.bottom.equalTo(weakSelf.expressNameLab);
    }];
    
    [_expressLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.chargeLineView.mas_right).offset(13.f);
        make.right.mas_equalTo(-12.f);
        make.width.bottom.height.equalTo(weakSelf.chargeLineView);
    }];
    
    [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(-44.f);
        make.width.mas_equalTo(weakSelf.iconImageView.mas_height).multipliedBy(302.f / 430.f);
    }];
}

@end
