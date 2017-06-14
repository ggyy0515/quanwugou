//
//  ECNewsBigImageViewCollectionViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"
#import "ECHomeNewsListModel.h"

@interface ECNewsBigImageViewCollectionViewCell : CMBaseCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath;

@property (strong,nonatomic) ECHomeNewsImageListModel *model;

@property (nonatomic, copy) void(^hideAction)();

@end
