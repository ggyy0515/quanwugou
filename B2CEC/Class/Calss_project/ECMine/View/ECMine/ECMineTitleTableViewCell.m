//
//  ECMineTitleTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMineTitleTableViewCell.h"

@interface ECMineTitleTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *detailLab;

@property (strong,nonatomic) UIView *redRoundView;

@property (strong,nonatomic) UIImageView *dirImageView;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECMineTitleTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECMineTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMineTitleTableViewCell)];
    if (cell == nil) {
        cell = [[ECMineTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMineTitleTableViewCell)];
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
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.font = FONT_28;
    _titleLab.textColor = DarkMoreColor;
    
    if (!_detailLab) {
        _detailLab = [UILabel new];
    }
    _detailLab.font = FONT_28;
    _detailLab.textColor = LightColor;
    _detailLab.textAlignment = NSTextAlignmentRight;
    
    if (!_redRoundView) {
        _redRoundView = [UIView new];
    }
    _redRoundView.backgroundColor = [UIColor redColor];
    _redRoundView.layer.cornerRadius = 4.f;
    _redRoundView.layer.masksToBounds = YES;
    _redRoundView.hidden = YES;
    
    if (!_dirImageView) {
        _dirImageView = [UIImageView new];
    }
    _dirImageView.image = [UIImage imageNamed:@"enter"];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_detailLab];
    [self.contentView addSubview:_redRoundView];
    [self.contentView addSubview:_dirImageView];
    [self.contentView addSubview:_lineView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(12.f);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(6.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.dirImageView.mas_left).offset(-8.f);
        make.left.mas_equalTo(weakSelf.titleLab.mas_right).offset(12.f);
    }];
    
    [_redRoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8.f, 8.f));
        make.right.mas_equalTo(weakSelf.dirImageView.mas_left).offset(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_dirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setIconImage:(NSString *)iconImage WithTitle:(NSString *)title{
    WEAK_SELF
    _iconImageView.image = [UIImage imageNamed:iconImage];
    _titleLab.text = title;
    
    if (iconImage.length == 0 || iconImage == nil) {
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
            make.left.mas_equalTo(12.f);
        }];
        
        [_titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.f);
            make.top.bottom.mas_equalTo(0.f);
        }];
    }else{
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
            make.left.mas_equalTo(12.f);
        }];
        
        [_titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(6.f);
            make.top.bottom.mas_equalTo(0.f);
        }];
    }
    [self.contentView layoutIfNeeded];
}

- (void)setDetailTitle:(NSString *)detailTitle{
    _detailTitle = detailTitle;
    _detailLab.text = detailTitle == nil ? @"" : detailTitle;
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    _titleLab.font = titleFont;
}

- (void)setDetailFont:(UIFont *)detailFont{
    _detailFont = detailFont;
    _detailLab.font = detailFont;
}

- (void)setShowDir:(BOOL)showDir{
    _showDir = showDir;
    _dirImageView.hidden = !showDir;
}

- (void)setShowRedRound:(BOOL)showRedRound{
    _showRedRound = showRedRound;
    _redRoundView.hidden = !showRedRound;
}

@end
