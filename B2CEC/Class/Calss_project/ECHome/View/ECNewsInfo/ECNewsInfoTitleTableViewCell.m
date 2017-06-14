//
//  ECNewsInfoTitleTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsInfoTitleTableViewCell.h"

@interface ECNewsInfoTitleTableViewCell()

@property (strong,nonatomic) UIView *lineView1;

@property (strong,nonatomic) UIView *noneView;

@property (strong,nonatomic) UIView *lineView2;

@property (strong,nonatomic) UILabel *titlelab;

@property (strong,nonatomic) UIView *lineView3;

@end

@implementation ECNewsInfoTitleTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECNewsInfoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoTitleTableViewCell)];
    if (cell == nil) {
        cell = [[ECNewsInfoTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoTitleTableViewCell)];
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
    
    if (!_noneView) {
        _noneView = [UIView new];
    }
    _noneView.backgroundColor = BaseColor;
    
    if (!_titlelab) {
        _titlelab = [UILabel new];
    }
    _titlelab.text = @"相关资讯";
    _titlelab.font = FONT_28;
    _titlelab.textColor = LightColor;
    
    if (!_lineView1) {
        _lineView1 = [UIView new];
    }
    _lineView1.backgroundColor = LineDefaultsColor;
    
    if (!_lineView2) {
        _lineView2 = [UIView new];
    }
    _lineView2.backgroundColor = LineDefaultsColor;
    
    if (!_lineView3) {
        _lineView3 = [UIView new];
    }
    _lineView3.backgroundColor = LineDefaultsColor;
    
    
    [self.contentView addSubview:_noneView];
    [self.contentView addSubview:_titlelab];
    [self.contentView addSubview:_lineView1];
    [self.contentView addSubview:_lineView2];
    [self.contentView addSubview:_lineView3];
    
    [_noneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(8.f);
    }];
    
    [_titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.noneView.mas_bottom);
        make.left.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.bottom.mas_equalTo(weakSelf.noneView.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setIsHiddenTitle:(BOOL)isHiddenTitle{
    _isHiddenTitle = isHiddenTitle;
    _titlelab.hidden = isHiddenTitle;
    _lineView3.hidden = isHiddenTitle;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titlelab.text = title;
}

@end
