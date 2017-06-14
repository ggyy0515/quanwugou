//
//  ECMineOrderCollectionViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECMineOrderCollectionViewCell : CMBaseCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath;

@property (strong,nonatomic) NSString *iconImage;

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *count;

@end
