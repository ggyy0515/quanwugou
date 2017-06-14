//
//  ECFilterCollectionViewCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECFilterCollectionViewCell : CMBaseCollectionViewCell

+ (instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy) NSString *title;

@property (strong, nonatomic) UILabel *titleLab;

@end
