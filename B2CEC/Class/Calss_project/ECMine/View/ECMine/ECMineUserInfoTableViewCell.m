//
//  ECMineUserInfoTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMineUserInfoTableViewCell.h"

@interface ECMineUserInfoTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UIImageView *nameTypeImageView;

@property (strong,nonatomic) UILabel *focusNameLab;

@property (strong,nonatomic) UILabel *focusDataLab;

@property (strong,nonatomic) UILabel *fansNameLab;

@property (strong,nonatomic) UILabel *fansDataLab;

@property (strong,nonatomic) UILabel *worksNameLab;

@property (strong,nonatomic) UILabel *worksDataLab;

@property (strong,nonatomic) UIImageView *dirImageView;

@property (strong,nonatomic) UILabel *loginLab;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECMineUserInfoTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECMineUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMineUserInfoTableViewCell)];
    if (cell == nil) {
        cell = [[ECMineUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMineUserInfoTableViewCell)];
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
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"face1"];
    _iconImageView.layer.cornerRadius = 30.f;
    _iconImageView.layer.masksToBounds = YES;
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.text = @"我是昵称";
    _nameLab.textColor = DarkMoreColor;
    _nameLab.font = FONT_32;
    
    if (!_nameTypeImageView) {
        _nameTypeImageView = [UIImageView new];
    }
    _nameTypeImageView.image = [UIImage imageNamed:@"desinger_icon"];
    
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
    
    if (!_dirImageView) {
        _dirImageView = [UIImageView new];
    }
    _dirImageView.image = [UIImage imageNamed:@"enter"];
    
    if (!_loginLab) {
        _loginLab = [UILabel new];
    }
    _loginLab.text = @"登录/注册";
    _loginLab.textColor = MainColor;
    _loginLab.font = [UIFont systemFontOfSize:18.f];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_nameTypeImageView];
    [self.contentView addSubview:_focusNameLab];
    [self.contentView addSubview:_focusDataLab];
    [self.contentView addSubview:_fansNameLab];
    [self.contentView addSubview:_fansDataLab];
    [self.contentView addSubview:_worksNameLab];
    [self.contentView addSubview:_worksDataLab];
    [self.contentView addSubview:_dirImageView];
    [self.contentView addSubview:_loginLab];
    [self.contentView addSubview:_lineView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 60.f));
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(16.f);
        make.bottom.mas_equalTo(weakSelf.iconImageView.mas_centerY).offset(-5.f);
    }];
    
    [_nameTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.f, 16.f));
        make.centerY.mas_equalTo(weakSelf.nameLab.mas_centerY);
        make.left.mas_equalTo(weakSelf.nameLab.mas_right).offset(8.f);
    }];
    
    [_focusNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.iconImageView.mas_centerY).offset(5.f);
        make.left.mas_equalTo(weakSelf.nameLab.mas_left);
    }];
    
    [_focusDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.focusNameLab.mas_right);
    }];
    
    [_fansNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.focusDataLab.mas_right).offset(12.f);
    }];
    
    [_fansDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.fansNameLab.mas_right);
    }];
    
    [_worksNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.fansDataLab.mas_right).offset(12.f);
    }];
    
    [_worksDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.worksNameLab.mas_right);
    }];
    
    [_dirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(16.f);
        make.centerY.mas_equalTo(weakSelf.iconImageView.mas_centerY);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setType:(NSInteger)type{
    _type = type;
    _loginLab.hidden = type != -1;
    _nameLab.hidden = type == -1;
    _nameTypeImageView.hidden = type == -1;
    _focusNameLab.hidden = type == -1;
    _focusDataLab.hidden = type == -1;
    _fansNameLab.hidden = type == -1;
    _fansDataLab.hidden = type == -1;
    _worksNameLab.hidden = type == -1;
    _worksDataLab.hidden = type == -1;
}

- (void)setModel:(ECMineModel *)model{
    _model = model;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.user.TITLE_IMG)] placeholder:[UIImage imageNamed:@"face1"]];
    _nameLab.text = model.user.NAME;
    _focusDataLab.text = model.ATTENTION_COUNT;
    _fansDataLab.text = model.FANS_COUNT;
    _worksDataLab.text = model.WORK_COUNT;
    switch (model.user.RIGHTS.integerValue) {
        case 0:{
            _nameTypeImageView.hidden = YES;
            _worksNameLab.text = @"文章";
        }
            break;
        case 1:{
            _nameTypeImageView.hidden = NO;
            _nameTypeImageView.image = [UIImage imageNamed:@"vip_icon"];
            _worksNameLab.text = @"文章";
        }
            break;
        default:{
            _nameTypeImageView.hidden = NO;
            _nameTypeImageView.image = [UIImage imageNamed:@"desinger_icon"];
            _worksNameLab.text = @"案例";
        }
            break;
    }
}

@end
