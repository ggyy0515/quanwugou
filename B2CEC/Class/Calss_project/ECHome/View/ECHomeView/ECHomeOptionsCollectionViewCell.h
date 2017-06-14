//
//  ECHomeOptionsCollectionViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECHomeOptionsCollectionViewCell : CMBaseCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath;

@property (strong,nonatomic) NSString *title;

@property (assign,nonatomic) BOOL isCurrent;

@end
