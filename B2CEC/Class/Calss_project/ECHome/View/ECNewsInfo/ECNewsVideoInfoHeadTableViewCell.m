//
//  ECNewsVideoInfoHeadTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsVideoInfoHeadTableViewCell.h"

@interface ECNewsVideoInfoHeadTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIView *likeView;

@property (strong,nonatomic) UIImageView *likeImageView;

@property (strong,nonatomic) UILabel *likeLab;

@property (strong,nonatomic) UIButton *likeBtn;

@property (strong,nonatomic) UIView *disLikeView;

@property (strong,nonatomic) UIImageView *disLikeImageView;

@property (strong,nonatomic) UILabel *disLikeLab;

@property (strong,nonatomic) UIButton *disLikeBtn;

@property (strong,nonatomic) UIButton *reportBtn;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIImageView *authImageView;

@property (strong,nonatomic) UILabel *authLab;

@property (strong,nonatomic) UILabel *authTypeLab;

@property (strong,nonatomic) UILabel *dateLab;

@property (strong,nonatomic) UIButton *focusBtn;

@end

@implementation ECNewsVideoInfoHeadTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECNewsVideoInfoHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsVideoInfoHeadTableViewCell)];
    if (cell == nil) {
        cell = [[ECNewsVideoInfoHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsVideoInfoHeadTableViewCell)];
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
    _titleLab.font = [UIFont boldSystemFontOfSize:24.f];
    _titleLab.textColor = DarkColor;
    _titleLab.numberOfLines = 0;
    
    if (!_likeView) {
        _likeView = [UIView new];
    }
    _likeView.layer.cornerRadius = 16.f;
    _likeView.layer.masksToBounds = YES;
    _likeView.layer.borderColor = LineDefaultsColor.CGColor;
    _likeView.layer.borderWidth = 1.f;
    
    if (!_likeImageView) {
        _likeImageView = [UIImageView new];
    }
    
    if (!_likeLab) {
        _likeLab = [UILabel new];
    }
    _likeLab.font = FONT_28;
    _likeLab.textColor = LightColor;
    
    if (!_likeBtn) {
        _likeBtn = [UIButton new];
    }
    [_likeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.mode.praiseType.integerValue == 0) {
            if (weakSelf.praiseClickBlock) {
                weakSelf.praiseClickBlock(YES);
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"您已选择,请勿重复选择！"];
        }
    }];
    
    if (!_disLikeView) {
        _disLikeView = [UIView new];
    }
    _disLikeView.layer.cornerRadius = 16.f;
    _disLikeView.layer.masksToBounds = YES;
    _disLikeView.layer.borderColor = LineDefaultsColor.CGColor;
    _disLikeView.layer.borderWidth = 1.f;
    
    if (!_disLikeImageView) {
        _disLikeImageView = [UIImageView new];
    }
    
    if (!_disLikeLab) {
        _disLikeLab = [UILabel new];
    }
    _disLikeLab.font = FONT_28;
    _disLikeLab.textColor = LightColor;
    
    if (!_disLikeBtn) {
        _disLikeBtn = [UIButton new];
    }
    [_disLikeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.mode.praiseType.integerValue == 0) {
            if (weakSelf.praiseClickBlock) {
                weakSelf.praiseClickBlock(NO);
            }
        }else{
            [SVProgressHUD showInfoWithStatus:@"您已选择,请勿重复选择！"];
        }
    }];
    
    if (!_reportBtn) {
        _reportBtn = [UIButton new];
    }
    [_reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [_reportBtn setTitleColor:LightColor forState:UIControlStateNormal];
    _reportBtn.titleLabel.font = FONT_28;
    [_reportBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.reportClickBlock) {
            weakSelf.reportClickBlock();
        }
    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    if (!_authImageView) {
        _authImageView = [UIImageView new];
    }
    _authImageView.layer.cornerRadius = 16.f;
    _authImageView.layer.masksToBounds = YES;
    _authImageView.image = [UIImage imageNamed:@"placeholder_News2"];
    
    if (!_authLab) {
        _authLab = [UILabel new];
    }
    _authLab.font = FONT_28;
    _authLab.textColor = DarkMoreColor;
    
    if (!_authTypeLab) {
        _authTypeLab = [UILabel new];
    }
    _authTypeLab.font = [UIFont systemFontOfSize:10.f];
    _authTypeLab.textColor = LightMoreColor;
    _authTypeLab.layer.borderColor = LineDefaultsColor.CGColor;
    _authTypeLab.layer.borderWidth = 0.5f;
    _authTypeLab.textAlignment = NSTextAlignmentCenter;
    
    if (!_dateLab) {
        _dateLab = [UILabel new];
    }
    _dateLab.font = FONT_24;
    _dateLab.textColor = LightColor;
    
    if (!_focusBtn) {
        _focusBtn = [UIButton new];
    }
    [_focusBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_focusBtn setTitle:@"√ 已关注" forState:UIControlStateSelected];
    [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _focusBtn.backgroundColor = MainColor;
    _focusBtn.layer.cornerRadius = 5.f;
    _focusBtn.layer.masksToBounds = YES;
    _focusBtn.titleLabel.font = FONT_28;
    _focusBtn.hidden = YES;
    [_focusBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.focusClickBlock) {
            weakSelf.focusClickBlock(weakSelf.focusBtn.selected);
        }
    }];
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_likeView];
    [_likeView addSubview:_likeImageView];
    [_likeView addSubview:_likeLab];
    [_likeView addSubview:_likeBtn];
    [self.contentView addSubview:_disLikeView];
    [_disLikeView addSubview:_disLikeImageView];
    [_disLikeView addSubview:_disLikeLab];
    [_disLikeView addSubview:_disLikeBtn];
    [self.contentView addSubview:_reportBtn];
    [self.contentView addSubview:_lineView];
    [self.contentView addSubview:_authImageView];
    [self.contentView addSubview:_authLab];
    [self.contentView addSubview:_authTypeLab];
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_focusBtn];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
        make.top.mas_equalTo(20.f);
    }];
    
    [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(76.f, 32.f));
        make.left.mas_equalTo(18.f);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom).offset(16.f);
    }];
    
    [_likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12.f, 12.f));
        make.centerY.mas_equalTo(weakSelf.likeView.mas_centerY);
        make.left.mas_equalTo(12.f);
    }];
    
    [_likeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.likeImageView.mas_right).offset(6.f);
        make.right.mas_equalTo(-6.f);
    }];
    
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_disLikeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(76.f, 32.f));
        make.left.mas_equalTo(weakSelf.likeView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom).offset(16.f);
    }];
    
    [_disLikeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12.f, 12.f));
        make.centerY.mas_equalTo(weakSelf.likeView.mas_centerY);
        make.left.mas_equalTo(12.f);
    }];
    
    [_disLikeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.disLikeImageView.mas_right).offset(6.f);
        make.right.mas_equalTo(-6.f);
    }];
    
    [_disLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16.f);
        make.centerY.mas_equalTo(weakSelf.disLikeView.mas_centerY);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
        make.top.mas_equalTo(weakSelf.likeView.mas_bottom).offset(20.f);
    }];
    
    [_authImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
        make.left.mas_equalTo(18.f);
        make.top.mas_equalTo(weakSelf.lineView.mas_bottom).offset(8.f);
    }];
    
    [_authLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.authImageView.mas_right).offset(12.f);
        make.bottom.mas_equalTo(weakSelf.authImageView.mas_centerY).offset(-2.f);
    }];
    
    [_authTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.authImageView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.authImageView.mas_centerY).offset(2.f);
        make.size.mas_equalTo(CGSizeMake(28.f, 14.f));
    }];
    
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.authTypeLab.mas_right).offset(5.f);
        make.top.mas_equalTo(weakSelf.authTypeLab.mas_top);
    }];
    
    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80.f, 32.f));
        make.right.mas_equalTo(-18.f);
        make.centerY.mas_equalTo(weakSelf.authImageView.mas_centerY);
    }];
}

- (void)setMode:(ECNewsInfomationModel *)mode{
    _mode = mode;
    _titleLab.text = mode.title;
    switch (mode.praiseType.integerValue) {
        case 0:{//未选择
            _likeImageView.image = [UIImage imageNamed:@"good"];
            _disLikeImageView.image = [UIImage imageNamed:@"nogood"];
        }
            break;
        case 1:{
            _likeImageView.image = [UIImage imageNamed:@"good_y"];
            _disLikeImageView.image = [UIImage imageNamed:@"nogood"];
        }
            break;
        case 2:{
            _likeImageView.image = [UIImage imageNamed:@"good"];
            _disLikeImageView.image = [UIImage imageNamed:@"nogood_y"];
        }
            break;
    }
    _likeLab.text = mode.praise;
    _disLikeLab.text = mode.Boo;
    _authLab.text = mode.resource;
    switch (mode.isoriginal.integerValue) {
        case 0:{
            _authTypeLab.text = @"原创";
            _focusBtn.hidden = NO;
            _focusBtn.selected = [mode.isattention isEqualToString:@"1"];
        }
            break;
        case 1:{
            _authTypeLab.text = @"转载";
            _focusBtn.hidden = YES;
        }
            break;
    }
    _focusBtn.hidden = YES;
    _dateLab.text = mode.createdate;
}

@end
