//
//  ECOrderSingleProductCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECOrderListModel;

@interface ECOrderSingleProductCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECOrderListModel *model;
@property (nonatomic, copy) void(^clickActionBtn)(NSString *BtnTitle);

@end
