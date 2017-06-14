//
//  ECPlaceOrderDesignerInfoTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPlaceOrderDesignerInfoTableViewCell.h"

@interface ECPlaceOrderDesignerInfoTableViewCell()

@property (strong,nonatomic) UILabel *typeLab;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UIView *lineView1;

@property (strong,nonatomic) UIView *lineView2;

@end

@implementation ECPlaceOrderDesignerInfoTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECPlaceOrderDesignerInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPlaceOrderDesignerInfoTableViewCell)];
    if (cell == nil) {
        cell = [[ECPlaceOrderDesignerInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPlaceOrderDesignerInfoTableViewCell)];
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
    if (!_typeLab) {
        _typeLab = [UILabel new];
    }
    _typeLab.text = @"设计师";
    _typeLab.textColor = LightMoreColor;
    _typeLab.font = FONT_32;
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.textColor = LightMoreColor;
    _nameLab.font = FONT_28;
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"face1"];
    _iconImageView.layer.cornerRadius = 25.f;
    _iconImageView.layer.masksToBounds = YES;
    
    if (!_lineView1) {
        _lineView1 = [UIView new];
    }
    _lineView1.backgroundColor = LineDefaultsColor;
    
    if (!_lineView2) {
        _lineView2 = [UIView new];
    }
    _lineView2.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_typeLab];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_lineView1];
    [self.contentView addSubview:_lineView2];
    
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(12.f);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.iconImageView.mas_left).offset(-10.f);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setDesignerName:(NSString *)designerName{
    _designerName = designerName;
    _nameLab.text = designerName;
}

- (void)setDesignerTitleImage:(NSString *)designerTitleImage{
    _designerTitleImage = designerTitleImage;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(designerTitleImage)] placeholder:[UIImage imageNamed:@"face1"]];
}

@end
