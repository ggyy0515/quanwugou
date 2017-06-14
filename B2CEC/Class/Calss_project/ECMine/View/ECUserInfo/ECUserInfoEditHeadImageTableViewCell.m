//
//  ECUserInfoEditHeadImageTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoEditHeadImageTableViewCell.h"

@interface ECUserInfoEditHeadImageTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *tipsLab;

@property (strong,nonatomic) UIImageView *dirImageView;

@end

@implementation ECUserInfoEditHeadImageTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECUserInfoEditHeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoEditHeadImageTableViewCell)];
    if (cell == nil) {
        cell = [[ECUserInfoEditHeadImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoEditHeadImageTableViewCell)];
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
    _iconImageView.layer.cornerRadius = 49.f / 2.f;
    _iconImageView.layer.masksToBounds = YES;
    
    if (!_tipsLab) {
        _tipsLab = [UILabel new];
    }
    _tipsLab.text = @"编辑头像";
    _tipsLab.textColor = LightColor;
    _tipsLab.font = FONT_32;
    
    if (!_dirImageView) {
        _dirImageView = [UIImageView new];
    }
    _dirImageView.image = [UIImage imageNamed:@"enter"];
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_tipsLab];
    [self.contentView addSubview:_dirImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(49.f, 49.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(12.f);
    }];
    
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(27.f);
    }];
    
    [_dirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    if (iconImage != nil) {
        _iconImageView.image = iconImage;
    }
}

- (void)setIconImageUrl:(NSString *)iconImageUrl{
    _iconImageUrl = iconImageUrl;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(iconImageUrl)] placeholder:[UIImage imageNamed:@"face1"]];
}

@end
