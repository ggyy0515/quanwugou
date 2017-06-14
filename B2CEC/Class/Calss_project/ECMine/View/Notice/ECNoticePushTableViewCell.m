//
//  ECNoticePushTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNoticePushTableViewCell.h"
#import "ECNoticePushModel.h"

@interface ECNoticePushTableViewCell()

@property (strong,nonatomic) UILabel *timeLab;

@property (strong,nonatomic) UIView *centerView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *contentLab;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UILabel *allLab;

@property (strong,nonatomic) UIImageView *allImageView;

@property (strong,nonatomic) UIButton *allBtn;

@end

@implementation ECNoticePushTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECNoticePushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNoticePushTableViewCell)];
    if (cell == nil) {
        cell = [[ECNoticePushTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNoticePushTableViewCell)];
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
    if (!_timeLab) {
        _timeLab = [UILabel new];
    }
    _timeLab.textColor = LightColor;
    _timeLab.font = FONT_24;
    _timeLab.textAlignment = NSTextAlignmentCenter;
    
    if (!_centerView) {
        _centerView = [UIView new];
    }
    _centerView.backgroundColor = [UIColor whiteColor];
    _centerView.layer.borderColor = LineDefaultsColor.CGColor;
    _centerView.layer.borderWidth = 0.5f;
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.textColor = DarkMoreColor;
    _titleLab.font = FONT_32;
    
    if (!_contentLab) {
        _contentLab = [UILabel new];
    }
    _contentLab.textColor = LightMoreColor;
    _contentLab.font = FONT_28;
    _contentLab.numberOfLines = 0;
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    if (!_allLab) {
        _allLab = [UILabel new];
    }
    _allLab.textColor = MainColor;
    _allLab.font = FONT_28;
    
    if (!_allImageView) {
        _allImageView = [UIImageView new];
    }
    
    if (!_allBtn) {
        _allBtn = [UIButton new];
    }
    [_allBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.showAllBlock) {
            weakSelf.showAllBlock(weakSelf.indexPath.row);
        }
    }];
    
    [self.contentView addSubview:_timeLab];
    [self.contentView addSubview:_centerView];
    [_centerView addSubview:_titleLab];
    [_centerView addSubview:_contentLab];
    [_centerView addSubview:_lineView];
    [_centerView addSubview:_allLab];
    [_centerView addSubview:_allImageView];
    [_centerView addSubview:_allBtn];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30.f);
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
    }];
    
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.timeLab.mas_bottom).offset(12.f);
        make.bottom.mas_equalTo(0.f);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(20.f);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLab);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom).offset(16.f);
        make.bottom.mas_equalTo(weakSelf.lineView.mas_top).offset(-16.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLab);
        make.height.mas_equalTo(0.5f);
        make.bottom.mas_equalTo(-44.f);
    }];
    
    [_allLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.height.mas_equalTo(44.f);
        make.bottom.mas_equalTo(0.f);
    }];
    
    [_allImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.allLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18.f, 10.f));
    }];
    
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(44.f);
    }];
}

- (void)setModel:(ECNoticePushModel *)model{
    _model = model;
    _timeLab.text = model.addtime;
    _titleLab.text = model.title;
    _contentLab.text = model.content;
}

- (void)setIsShowAll:(BOOL)isShowAll{
    _isShowAll = isShowAll;
    
    _allLab.text = isShowAll ? @"收起全部" : @"查看全部";
    _allImageView.image = isShowAll ? [UIImage imageNamed:@"nav_citymore_top"] : [UIImage imageNamed:@"nav_citymore"];
}

@end
