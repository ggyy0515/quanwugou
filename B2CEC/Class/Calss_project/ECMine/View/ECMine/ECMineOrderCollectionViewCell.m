//
//  ECMineOrderCollectionViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMineOrderCollectionViewCell.h"

@interface ECMineOrderCollectionViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *countLab;

@end

@implementation ECMineOrderCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath{
    ECMineOrderCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMineOrderCollectionViewCell) forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBasicUI];
    }
    return self;
}
- (void)createBasicUI{
    WEAK_SELF
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"desinger_icon"];
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.font = FONT_24;
    _titleLab.textColor = DarkMoreColor;
    _titleLab.text = @"待付款";
    
    if (!_countLab) {
        _countLab = [UILabel new];
    }
    _countLab.text = @"12";
    _countLab.textColor = [UIColor whiteColor];
    _countLab.font = FONT_22;
    _countLab.backgroundColor = CompColor;
    _countLab.layer.cornerRadius = 8.f;
    _countLab.layer.masksToBounds = YES;
    _countLab.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_countLab];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(20.f);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom).offset(12.f);
    }];
    
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.f, 16.f));
        make.centerX.mas_equalTo(weakSelf.iconImageView.mas_right).offset(-4.f);
        make.centerY.mas_equalTo(weakSelf.iconImageView.mas_top).offset(4.f);
    }];
}

- (void)setIconImage:(NSString *)iconImage{
    _iconImage = iconImage;
    _iconImageView.image = [UIImage imageNamed:iconImage];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = title;
}

- (void)setCount:(NSString *)count{
    _count = count;
    _countLab.hidden = count.integerValue == 0;
    _countLab.text = count;
}

@end
