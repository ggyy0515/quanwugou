//
//  ECOrderDetailMessageCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECOrderListModel;

@interface ECOrderDetailMessageCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECOrderListModel *model;

@end
