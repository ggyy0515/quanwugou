//
//  ECPointOrderListCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECPointOrderListModel;

@interface ECPointOrderListCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECPointOrderListModel *model;

@end
