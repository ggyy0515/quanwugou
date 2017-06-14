//
//  ECUserInfoHeaderTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoHeaderTableViewCell.h"

@interface ECUserInfoHeaderTableViewCell()

@property (strong,nonatomic) UIImageView *bgImageView;

@property (strong,nonatomic) UIView *bottomView;

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UIImageView *nameTypeImageView;

@property (strong,nonatomic) UILabel *focusNameLab;

@property (strong,nonatomic) UILabel *focusDataLab;

@property (strong,nonatomic) UIButton *focusBtn;

@property (strong,nonatomic) UILabel *fansNameLab;

@property (strong,nonatomic) UILabel *fansDataLab;

@property (strong,nonatomic) UIButton *fansBtn;

@property (strong,nonatomic) UILabel *worksNameLab;

@property (strong,nonatomic) UILabel *worksDataLab;

@property (strong,nonatomic) UIButton *worksBtn;

@property (strong,nonatomic) UIButton *editBtn;

@end

@implementation ECUserInfoHeaderTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECUserInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoHeaderTableViewCell)];
    if (cell == nil) {
        cell = [[ECUserInfoHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoHeaderTableViewCell)];
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
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
    }
    _bgImageView.image = [UIImage imageNamed:@"my_top_bg"];
    
    if (!_bottomView) {
        _bottomView = [UIView new];
    }
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.5];
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"face1"];
    _iconImageView.layer.cornerRadius = 33.f;
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
    
    if (!_focusBtn) {
        _focusBtn = [UIButton new];
    }
    [_focusBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.typeClickBlock) {
            weakSelf.typeClickBlock(0);
        }
    }];
    
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
    
    if (!_fansBtn) {
        _fansBtn = [UIButton new];
    }
    [_fansBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.typeClickBlock) {
            weakSelf.typeClickBlock(1);
        }
    }];
    
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
    
    if (!_worksBtn) {
        _worksBtn = [UIButton new];
    }
    [_worksBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.typeClickBlock) {
            weakSelf.typeClickBlock(2);
        }
    }];
    
    if (!_editBtn) {
        _editBtn = [UIButton new];
    }
    [_editBtn setTitle:@"修改资料" forState:UIControlStateNormal];
    [_editBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _editBtn.titleLabel.font = FONT_24;
    _editBtn.layer.borderColor = MainColor.CGColor;
    _editBtn.layer.borderWidth = 1.f;
    _editBtn.layer.cornerRadius = 5.f;
    _editBtn.layer.masksToBounds = YES;
    [_editBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.editInfoBlock) {
            weakSelf.editInfoBlock();
        }
    }];
    
    [self.contentView addSubview:_bgImageView];
    [self.contentView addSubview:_bottomView];
    [self.contentView addSubview:_iconImageView];
    [_bottomView addSubview:_nameLab];
    [_bottomView addSubview:_nameTypeImageView];
    [_bottomView addSubview:_focusNameLab];
    [_bottomView addSubview:_focusDataLab];
    [_bottomView addSubview:_focusBtn];
    [_bottomView addSubview:_fansNameLab];
    [_bottomView addSubview:_fansDataLab];
    [_bottomView addSubview:_fansBtn];
    [_bottomView addSubview:_worksNameLab];
    [_bottomView addSubview:_worksDataLab];
    [_bottomView addSubview:_worksBtn];
    [_bottomView addSubview:_editBtn];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(64.f);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66.f, 66.f));
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(7.5f);
        make.top.mas_equalTo(10.f);
    }];
    
    [_nameTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.f, 16.f));
        make.centerY.mas_equalTo(weakSelf.nameLab.mas_centerY);
        make.left.mas_equalTo(weakSelf.nameLab.mas_right).offset(8.f);
    }];
    
    [_focusNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameLab.mas_bottom).offset(10.f);
        make.left.mas_equalTo(weakSelf.nameLab.mas_left);
    }];
    
    [_focusDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.focusNameLab.mas_right);
    }];
    
    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.focusNameLab.mas_left);
        make.right.mas_equalTo(weakSelf.focusDataLab.mas_right);
        make.centerY.mas_equalTo(weakSelf.focusNameLab.mas_centerY);
        make.height.mas_equalTo(15.f);
    }];
    
    [_fansNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.focusDataLab.mas_right).offset(12.f);
    }];
    
    [_fansDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.fansNameLab.mas_right);
    }];
    
    [_fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.fansNameLab.mas_left);
        make.right.mas_equalTo(weakSelf.fansDataLab.mas_right);
        make.centerY.mas_equalTo(weakSelf.fansNameLab.mas_centerY);
        make.height.mas_equalTo(15.f);
    }];
    
    [_worksNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.fansDataLab.mas_right).offset(12.f);
    }];
    
    [_worksDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.focusNameLab.mas_top);
        make.left.mas_equalTo(weakSelf.worksNameLab.mas_right);
    }];
    
    [_worksBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.worksNameLab.mas_left);
        make.right.mas_equalTo(weakSelf.worksDataLab.mas_right);
        make.centerY.mas_equalTo(weakSelf.worksNameLab.mas_centerY);
        make.height.mas_equalTo(15.f);
    }];
 
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68.f, 30.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.bottomView.mas_centerY);
    }];
}

- (void)setModel:(ECUserInfoModel *)model{
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

- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    _editBtn.hidden = !isEdit;
}

@end
