//
//  ECOrderMutilProductCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECOrderListModel;

@interface ECOrderMutilProductCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECOrderListModel *model;
@property (nonatomic, copy) void(^clickActionBtn)(NSString *BtnTitle);

@end
