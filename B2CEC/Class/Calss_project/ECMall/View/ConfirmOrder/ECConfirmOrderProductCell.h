//
//  ECConfirmOrderProductCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECCartProductModel;
@class ECPointProductListModel;

@interface ECConfirmOrderProductCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECCartProductModel *model;

/**
 积分兑换确认订单时候使用
 */
@property (nonatomic, strong) ECPointProductListModel *pointModel;

@property (nonatomic, copy) void(^refreshPrice)();

@end
