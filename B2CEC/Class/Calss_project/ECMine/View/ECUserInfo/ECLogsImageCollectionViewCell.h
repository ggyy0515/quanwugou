//
//  ECLogsImageCollectionViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECLogsImageCollectionViewCell : CMBaseCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath;

@property (strong,nonatomic) NSString *iconImage;

@end
