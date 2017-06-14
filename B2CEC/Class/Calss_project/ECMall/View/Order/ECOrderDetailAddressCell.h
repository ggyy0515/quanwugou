//
//  ECOrderDetailAddressCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECOrderListModel;

@class ECPointOrderDetailInfoModel;

@interface ECOrderDetailAddressCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECOrderListModel *model;

@property (nonatomic, strong) ECPointOrderDetailInfoModel *pointModel;

@end
