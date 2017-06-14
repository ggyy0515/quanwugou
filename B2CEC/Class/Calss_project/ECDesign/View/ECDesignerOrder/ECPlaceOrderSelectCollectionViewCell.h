//
//  ECPlaceOrderSelectCollectionViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECPlaceOrderSelectCollectionViewCell : CMBaseCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath;

@property (strong,nonatomic) NSString *name;

@property (assign,nonatomic) BOOL isCurrent;

@end
