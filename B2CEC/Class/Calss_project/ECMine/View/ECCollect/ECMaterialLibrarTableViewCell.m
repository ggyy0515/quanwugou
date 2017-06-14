//
//  ECMaterialLibrarTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMaterialLibrarTableViewCell.h"

@interface ECMaterialLibrarTableViewCell()

@property (strong,nonatomic) UIView *topView;

@property (strong,nonatomic) UIImageView *coverImageView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIImageView *collectImageView;

@property (strong,nonatomic) UILabel *collectLab;

@property (nonatomic, strong) UIButton *collectBtn;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECMaterialLibrarTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECMaterialLibrarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMaterialLibrarTableViewCell)];
    if (cell == nil) {
        cell = [[ECMaterialLibrarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMaterialLibrarTableViewCell)];
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
    if (!_topView) {
        _topView = [UIView new];
    }
    _topView.backgroundColor = BaseColor;
    
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
    }
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.textColor = DarkMoreColor;
    _titleLab.font = FONT_32;
    
    if (!_collectImageView) {
        _collectImageView = [UIImageView new];
    }
    
    if (!_collectLab) {
        _collectLab = [UILabel new];
    }
    _collectLab.font = FONT_24;
    _collectLab.textColor = LightColor;
    
    if (!_collectBtn) {
        _collectBtn = [UIButton new];
    }
    [_collectBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.collectBlock) {
            weakSelf.collectBlock(weakSelf.indexPath.row);
        }
    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_topView];
    [self.contentView addSubview:_coverImageView];
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_collectImageView];
    [self.contentView addSubview:_collectLab];
    [self.contentView addSubview:_collectBtn];
    [self.contentView addSubview:_lineView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(8.f);
    }];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom);
        make.bottom.mas_equalTo(-49.f);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(weakSelf.coverImageView.mas_bottom);
        make.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.collectImageView.mas_right).offset(-12.f);
    }];
    
    [_collectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.collectLab.mas_left).offset(-4.f);
        make.centerY.mas_equalTo(weakSelf.titleLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12.f, 12.F));
    }];
    
    [_collectLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(weakSelf.titleLab);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.collectImageView);
        make.right.bottom.equalTo(weakSelf.collectLab);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setModel:(ECMaterialLibraryModel *)model{
    _model = model;
    [_coverImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.url)] placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
    _titleLab.text = model.descri;
    _collectImageView.image = [model.isCollect isEqualToString:@"0"] ? [UIImage imageNamed:@"article_tabbar_like_b"] : [UIImage imageNamed:@"follow_b"];
    _collectLab.text = model.collect;
}

@end
