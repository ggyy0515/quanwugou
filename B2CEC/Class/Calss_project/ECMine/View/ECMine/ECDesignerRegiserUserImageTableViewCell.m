//
//  ECDesignerRegiserUserImageTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerRegiserUserImageTableViewCell.h"

@interface ECDesignerRegiserUserImageTableViewCell()

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UIImageView *dirImageView;

@property (strong,nonatomic) UIView *topLineView;

@property (strong,nonatomic) UIView *bottomLineView;

@end

@implementation ECDesignerRegiserUserImageTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerRegiserUserImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegiserUserImageTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerRegiserUserImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegiserUserImageTableViewCell)];
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
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.text = @"展示照片";
    _nameLab.font = FONT_32;
    _nameLab.textColor = LightMoreColor;
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    
    if (!_dirImageView) {
        _dirImageView = [UIImageView new];
    }
    _dirImageView.image = [UIImage imageNamed:@"enter"];
    
    if (!_topLineView) {
        _topLineView = [UIView new];
    }
    _topLineView.backgroundColor = LineDefaultsColor;
    
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
    }
    _bottomLineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_dirImageView];
    [self.contentView addSubview:_topLineView];
    [self.contentView addSubview:_bottomLineView];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35.f, 50.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.right.mas_equalTo(weakSelf.dirImageView.mas_left).offset(-16.f);
    }];
    
    [_dirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7.f, 15.f));
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
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
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(iconImageUrl)] placeholder:[UIImage imageNamed:@"placeholder_News2"]];
}

@end
