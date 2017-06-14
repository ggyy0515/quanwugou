//
//  ECWorksDetailUserInfoTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWorksDetailUserInfoTableViewCell.h"

@interface ECWorksDetailUserInfoTableViewCell()

@property (strong,nonatomic) UIImageView *bgImageView;

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UILabel *focusNameLab;

@property (strong,nonatomic) UILabel *focusDataLab;

@property (strong,nonatomic) UILabel *fansNameLab;

@property (strong,nonatomic) UILabel *fansDataLab;

@property (strong,nonatomic) UILabel *worksNameLab;

@property (strong,nonatomic) UILabel *worksDataLab;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIView *lineView1;

@property (strong,nonatomic) UIView *designerStyleView;

@property (strong,nonatomic) UIButton *styleBtn;

@property (strong,nonatomic) UIButton *typeBtn;

@property (strong,nonatomic) UIButton *houseBtn;

@property (strong,nonatomic) UIView *lineView2;

@end

@implementation ECWorksDetailUserInfoTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECWorksDetailUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWorksDetailUserInfoTableViewCell)];
    if (cell == nil) {
        cell = [[ECWorksDetailUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWorksDetailUserInfoTableViewCell)];
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
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
    }
    _bgImageView.image = [UIImage imageNamed:@"my_top_bg"];
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"face1"];
    _iconImageView.layer.cornerRadius = 32.f;
    _iconImageView.layer.masksToBounds = YES;
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.textColor = DarkMoreColor;
    _nameLab.font = FONT_32;
    
    if (!_focusNameLab) {
        _focusNameLab = [UILabel new];
    }
    _focusNameLab.text = @"关注";
    _focusNameLab.font = FONT_24;
    _focusNameLab.textColor = LightColor;
    
    if (!_focusDataLab) {
        _focusDataLab = [UILabel new];
    }
    _focusDataLab.text = @"123";
    _focusDataLab.font = FONT_24;
    _focusDataLab.textColor = DarkMoreColor;
    
    if (!_fansNameLab) {
        _fansNameLab = [UILabel new];
    }
    _fansNameLab.text = @"粉丝";
    _fansNameLab.font = FONT_24;
    _fansNameLab.textColor = LightColor;
    
    if (!_fansDataLab) {
        _fansDataLab = [UILabel new];
    }
    _fansDataLab.text = @"123";
    _fansDataLab.font = FONT_24;
    _fansDataLab.textColor = DarkMoreColor;
    
    if (!_worksNameLab) {
        _worksNameLab = [UILabel new];
    }
    _worksNameLab.text = @"案例";
    _worksNameLab.font = FONT_24;
    _worksNameLab.textColor = LightColor;
    
    if (!_worksDataLab) {
        _worksDataLab = [UILabel new];
    }
    _worksDataLab.text = @"123";
    _worksDataLab.font = FONT_24;
    _worksDataLab.textColor = DarkMoreColor;
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.font = [UIFont systemFontOfSize:21.f];
    _titleLab.textColor = DarkColor;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.numberOfLines = 0;
    
    if (!_lineView1) {
        _lineView1 = [UIView new];
    }
    _lineView1.backgroundColor = LineDefaultsColor;
    
    if (!_designerStyleView) {
        _designerStyleView = [UIView new];
    }
    
    if (!_styleBtn) {
        _styleBtn = [UIButton new];
    }
    [_styleBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    _styleBtn.titleLabel.font = FONT_28;
    _styleBtn.enabled = NO;
    
    if (!_typeBtn) {
        _typeBtn = [UIButton new];
    }
    [_typeBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    _typeBtn.titleLabel.font = FONT_28;
    _typeBtn.enabled = NO;
    
    if (!_houseBtn) {
        _houseBtn = [UIButton new];
    }
    [_houseBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    _houseBtn.titleLabel.font = FONT_28;
    _houseBtn.enabled = NO;
    
    if (!_lineView2) {
        _lineView2 = [UIView new];
    }
    _lineView2.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_bgImageView];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_focusNameLab];
    [self.contentView addSubview:_focusDataLab];
    [self.contentView addSubview:_fansNameLab];
    [self.contentView addSubview:_fansDataLab];
    [self.contentView addSubview:_worksNameLab];
    [self.contentView addSubview:_worksDataLab];
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_lineView1];
    [self.contentView addSubview:_designerStyleView];
    [_designerStyleView addSubview:_styleBtn];
    [_designerStyleView addSubview:_typeBtn];
    [_designerStyleView addSubview:_houseBtn];
    [self.contentView addSubview:_lineView2];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(SCREENWIDTH * (350.f / 750.f));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64.f, 64.f));
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.bgImageView.mas_bottom);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).offset(12.f);
    }];
    
    [_focusNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.focusDataLab.mas_left);
        make.top.mas_equalTo(weakSelf.fansNameLab.mas_top);
    }];
    
    [_focusDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.fansNameLab.mas_left).offset(-12.f);
        make.top.mas_equalTo(weakSelf.fansNameLab.mas_top);
    }];
    
    [_fansNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(weakSelf.nameLab.mas_bottom).offset(8.f);
    }];
    
    [_fansDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(weakSelf.fansNameLab.mas_top);
    }];
    
    [_worksNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.fansDataLab.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.fansNameLab.mas_top);
    }];
    
    [_worksDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.fansNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.worksNameLab.mas_right);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.fansNameLab.mas_bottom).offset(24.f);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLab);
        make.height.mas_equalTo(0.5f);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom).offset(24.f);
    }];
    
    [_designerStyleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom).offset(24.f);
        make.height.mas_equalTo(49.f);
    }];
    
    [_styleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.typeBtn.mas_left);
        make.width.mas_equalTo(weakSelf.typeBtn.mas_width);
    }];
    
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(weakSelf.styleBtn);
        make.left.mas_equalTo(weakSelf.styleBtn.mas_right);
        make.right.mas_equalTo(weakSelf.houseBtn.mas_left);
    }];
    
    [_houseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(weakSelf.styleBtn);
        make.left.mas_equalTo(weakSelf.typeBtn.mas_right);
        make.right.mas_equalTo(0.f);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.lineView1);
        make.bottom.mas_equalTo(0.f);
    }];
}

- (void)setModel:(ECWorksDetailModel *)model{
    _model = model;
    [_bgImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.cover)] placeholder:[UIImage imageNamed:@"my_top_bg"]];
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.user.TITLE_IMG)] placeholder:[UIImage imageNamed:@"face1"]];
    _nameLab.text = model.user.NAME;
    _focusDataLab.text = model.user.ATTENTION_COUNT;
    _fansDataLab.text = model.user.FANS_COUNT;
    _worksDataLab.text = model.user.WORK_COUNT;
    _titleLab.text = model.title;
    
    _designerStyleView.hidden = model.style.length == 0;
    _lineView2.hidden = model.style.length == 0;
    
    [_styleBtn setTitle:model.style forState:UIControlStateNormal];
    [_styleBtn setImage:[UIImage imageNamed:@"design_fengge"] forState:UIControlStateNormal];
    [_styleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, 0.f)];
    [_styleBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 6.f)];
    
    [_typeBtn setTitle:model.type forState:UIControlStateNormal];
    [_typeBtn setImage:[UIImage imageNamed:@"design_leixing"] forState:UIControlStateNormal];
    [_typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, 0.f)];
    [_typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 6.f)];
    
    [_houseBtn setTitle:model.housetype forState:UIControlStateNormal];
    [_houseBtn setImage:[UIImage imageNamed:@"design_fangxing"] forState:UIControlStateNormal];
    [_houseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, 0.f)];
    [_houseBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 6.f)];
}

@end
