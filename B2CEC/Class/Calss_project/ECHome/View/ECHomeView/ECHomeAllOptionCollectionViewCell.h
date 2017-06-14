//
//  ECHomeAllOptionCollectionViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/16.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"
#import "ECNewsTypeModel.h"

@interface ECHomeAllOptionCollectionViewCell : CMBaseCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath;

@property (strong,nonatomic) ECNewsTypeModel *model;

@property (assign,nonatomic) BOOL isDelete;

@property (assign,nonatomic) BOOL isFixed;

@end
