//
//  ECHomeAdvertisingTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeAdvertisingTableViewCell.h"

@interface ECHomeAdvertisingTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *tipsLab;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECHomeAdvertisingTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECHomeAdvertisingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeAdvertisingTableViewCell)];
    if (cell == nil) {
        cell = [[ECHomeAdvertisingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECHomeAdvertisingTableViewCell)];
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
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"placeholder_News1"];
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"我是一个默默无闻的传送门";
    _titleLab.font = FONT_32;
    _titleLab.textColor = DarkColor;
    
    if (!_tipsLab) {
        _tipsLab = [UILabel new];
    }
    _tipsLab.text = @"广告";
    _tipsLab.font = FONT_28;
    _tipsLab.textColor = LightColor;
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_tipsLab];
    [self.contentView addSubview:_lineView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
        make.height.mas_equalTo(weakSelf.iconImageView.mas_width).multipliedBy(190.f / 678.f);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.bottom.mas_equalTo(-18.f);
    }];
    
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(-18.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
        make.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(_imageUrl)] placeholder:[UIImage imageNamed:@"placeholder_News1"]];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = _title;
}

@end
