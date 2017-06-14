//
//  ECPlaceOrderSelectCollectionViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPlaceOrderSelectCollectionViewCell.h"

@interface ECPlaceOrderSelectCollectionViewCell()

@property (strong,nonatomic) UIImageView *bgImageView;

@property (strong,nonatomic) UILabel *nameLab;

@end

@implementation ECPlaceOrderSelectCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath{
    ECPlaceOrderSelectCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPlaceOrderSelectCollectionViewCell) forIndexPath:indexPath];
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
    
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
    }
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.font = FONT_22;
    _nameLab.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_bgImageView];
    [self.contentView addSubview:_nameLab];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(17.f);
    }];
}

- (void)setName:(NSString *)name{
    _name = name;
    _nameLab.text = name;
}

- (void)setIsCurrent:(BOOL)isCurrent{
    _isCurrent = isCurrent;
    _bgImageView.image = isCurrent ? [UIImage imageNamed:@"标签底图_选中"] : [UIImage imageNamed:@"标签底图_正常"];
    _nameLab.textColor = isCurrent ? [UIColor whiteColor] : DarkMoreColor;
}

@end
