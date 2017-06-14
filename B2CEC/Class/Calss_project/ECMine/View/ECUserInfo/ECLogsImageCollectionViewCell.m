//
//  ECLogsImageCollectionViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECLogsImageCollectionViewCell.h"

@interface ECLogsImageCollectionViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@end

@implementation ECLogsImageCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath{
    ECLogsImageCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLogsImageCollectionViewCell) forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBasicUI];
    }
    return self;
}
- (void)createBasicUI{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    
    [self.contentView addSubview:_iconImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)setIconImage:(NSString *)iconImage{
    _iconImage = iconImage;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(iconImage)] placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
}

@end
