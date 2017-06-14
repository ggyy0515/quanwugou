//
//  ECOrderDetailProductCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECOrderProductModel;

@interface ECOrderDetailProductCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECOrderProductModel *model;

@end
