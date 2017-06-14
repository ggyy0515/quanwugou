//
//  ECOrderListProductCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECOrderProductModel;

@interface ECOrderListProductCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECOrderProductModel *model;

@end
