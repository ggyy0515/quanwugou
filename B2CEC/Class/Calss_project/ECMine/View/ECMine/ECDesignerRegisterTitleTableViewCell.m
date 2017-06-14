//
//  ECDesignerRegisterTitleTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/30.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerRegisterTitleTableViewCell.h"

@interface ECDesignerRegisterTitleTableViewCell()

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *detailLab;

@property (strong,nonatomic) UIView *topLineView;

@property (strong,nonatomic) UIView *bottomLineView;

@end

@implementation ECDesignerRegisterTitleTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerRegisterTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterTitleTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerRegisterTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterTitleTableViewCell)];
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
    _titleLab.font = FONT_32;
    _titleLab.textColor = LightMoreColor;
    
    if (!_detailLab) {
        _detailLab = [UILabel new];
    }
    _detailLab.textColor = LightColor;
    _detailLab.font = FONT_28;
    
    if (!_topLineView) {
        _topLineView = [UIView new];
    }
    _topLineView.backgroundColor = LineDefaultsColor;
    
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
    }
    _bottomLineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_detailLab];
    [self.contentView addSubview:_topLineView];
    [self.contentView addSubview:_bottomLineView];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.titleLab.mas_right).offset(3.f);
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

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = title;
}

- (void)setDetailTitle:(NSString *)detailTitle{
    _detailTitle = detailTitle;
    _detailLab.text = detailTitle;
}

@end
