//
//  ECUserInfoEvaluationCommentImageCollectionViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/19.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoEvaluationCommentImageCollectionViewCell.h"

@interface ECUserInfoEvaluationCommentImageCollectionViewCell()

@property (strong,nonatomic) UIImageView *imageView;

@end

@implementation ECUserInfoEvaluationCommentImageCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath{
    ECUserInfoEvaluationCommentImageCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoEvaluationCommentImageCollectionViewCell) forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBasicUI];
    }
    return self;
}
- (void)createBasicUI{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    _imageView.image = [UIImage imageNamed:@"placeholder_goods2"];
    
    [self.contentView addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(imageUrl)] placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
}

@end
