//
//  ECDesignerTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerTableViewCell.h"

@interface ECDesignerTableViewCell()

@property (strong,nonatomic) UIView *topNonoView;

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UILabel *focusNameLab;

@property (strong,nonatomic) UILabel *focusDataLab;

@property (strong,nonatomic) UILabel *fansNameLab;

@property (strong,nonatomic) UILabel *fansDataLab;

@property (strong,nonatomic) UILabel *worksNameLab;

@property (strong,nonatomic) UILabel *worksDataLab;

@property (strong,nonatomic) UIButton *focusBtn;

@property (strong,nonatomic) UIImageView *firstImageView;

@property (strong,nonatomic) UIImageView *secondImageView;

@property (strong,nonatomic) UIImageView *thirdImageView;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECDesignerTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerTableViewCell)];
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
    if (!_topNonoView) {
        _topNonoView = [UIView new];
    }
    _topNonoView.backgroundColor = BaseColor;
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"face1"];
    _iconImageView.layer.cornerRadius = 43.f / 2.f;
    _iconImageView.layer.masksToBounds = YES;
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.text = @"我是昵称";
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
    
    if (!_focusBtn) {
        _focusBtn = [UIButton new];
    }
    [_focusBtn setTitle:@"加关注" forState:UIControlStateNormal];
    [_focusBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_focusBtn setTitleColor:LightColor forState:UIControlStateSelected];
    _focusBtn.titleLabel.font = FONT_28;
    _focusBtn.layer.cornerRadius = 4.f;
    _focusBtn.layer.masksToBounds = YES;
    [_focusBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.focusClickBlock) {
            weakSelf.focusClickBlock(weakSelf.indexPath.row);
        }
    }];
    
    if (!_firstImageView) {
        _firstImageView = [UIImageView new];
    }
    _firstImageView.image = [UIImage imageNamed:@"no_designer"];
    
    if (!_secondImageView) {
        _secondImageView = [UIImageView new];
    }
    _secondImageView.hidden = YES;
    _secondImageView.image = [UIImage imageNamed:@"no_designer"];
    
    if (!_thirdImageView) {
        _thirdImageView = [UIImageView new];
    }
    _thirdImageView.hidden = YES;
    _thirdImageView.image = [UIImage imageNamed:@"no_designer"];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_topNonoView];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_focusNameLab];
    [self.contentView addSubview:_focusDataLab];
    [self.contentView addSubview:_fansNameLab];
    [self.contentView addSubview:_fansDataLab];
    [self.contentView addSubview:_worksNameLab];
    [self.contentView addSubview:_worksDataLab];
    [self.contentView addSubview:_focusBtn];
    [self.contentView addSubview:_firstImageView];
    [self.contentView addSubview:_secondImageView];
    [self.contentView addSubview:_thirdImageView];
    [self.contentView addSubview:_lineView];
    
    [_topNonoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(8.f);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(43.f, 43.f));
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(weakSelf.topNonoView.mas_bottom).offset(14.f);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.topNonoView.mas_bottom).offset(20.f);
    }];
    
    [_focusNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameLab.mas_bottom).offset(6.f);
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
    
    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64.f, 32.f));
        make.centerY.mas_equalTo(weakSelf.iconImageView.mas_centerY);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).offset(20.f);
        make.bottom.mas_equalTo(-16.f);
        make.width.mas_equalTo(weakSelf.secondImageView.mas_width);
        make.right.mas_equalTo(weakSelf.secondImageView.mas_left).offset(-8.f);
    }];
    
    [_secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(weakSelf.firstImageView);
        make.left.mas_equalTo(weakSelf.firstImageView.mas_right).offset(8.f);
        make.right.mas_equalTo(weakSelf.thirdImageView.mas_left).offset(-8.f);
    }];
    
    [_thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(weakSelf.firstImageView);
        make.left.mas_equalTo(weakSelf.secondImageView.mas_right).offset(8.f);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setModel:(ECDesignerModel *)model{
    _model = model;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.TITLE_IMG)] placeholder:[UIImage imageNamed:@"face1"]];
    _nameLab.text = model.NAME;
    _focusDataLab.text = model.ATTENTION_COUNT;
    _fansDataLab.text = model.FANS_COUNT;
    _worksDataLab.text = model.WORK_COUNT;
    
    if ([model.ATTENTION isEqualToString:@"1"] || model.ATTENTION.length == 0) {
        _focusBtn.backgroundColor = [UIColor whiteColor];
        _focusBtn.selected = YES;
        _focusBtn.layer.borderColor = LightColor.CGColor;
        _focusBtn.layer.borderWidth = 1.f;
    }else{
        _focusBtn.backgroundColor = DarkMoreColor;
        _focusBtn.selected = NO;
        _focusBtn.layer.borderColor = ClearColor.CGColor;
        _focusBtn.layer.borderWidth = 1.f;
    }
    
    _focusBtn.hidden = [model.USER_ID isEqualToString:[Keychain objectForKey:EC_USER_ID]];
    
    switch (model.coverList.count) {
        case 0:{
            _firstImageView.hidden = NO;
            _secondImageView.hidden = YES;
            _thirdImageView.hidden = YES;
            
            _firstImageView.image = [UIImage imageNamed:@"no_designer"];
        }
            break;
        case 1:{
            _firstImageView.hidden = NO;
            _secondImageView.hidden = YES;
            _thirdImageView.hidden = YES;
            
            [_firstImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.coverList[0])] placeholder:[UIImage imageNamed:@"no_designer"]];
        }
            break;
        case 2:{
            _firstImageView.hidden = NO;
            _secondImageView.hidden = NO;
            _thirdImageView.hidden = YES;
            
            [_firstImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.coverList[0])] placeholder:[UIImage imageNamed:@"no_designer"]];
            [_secondImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.coverList[1])] placeholder:[UIImage imageNamed:@"no_designer"]];
        }
            break;
        default:{
            _firstImageView.hidden = NO;
            _secondImageView.hidden = NO;
            _thirdImageView.hidden = NO;
            
            [_firstImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.coverList[0])] placeholder:[UIImage imageNamed:@"no_designer"]];
            [_secondImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.coverList[1])] placeholder:[UIImage imageNamed:@"no_designer"]];
            [_thirdImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.coverList[2])] placeholder:[UIImage imageNamed:@"no_designer"]];
        }
            break;
    }
}

@end
