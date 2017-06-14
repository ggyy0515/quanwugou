//
//  ECMallProductCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECMallProductModel;

@class ECPointProductListModel;

@interface ECMallProductCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECMallProductModel *model;

/**
 在积分商城商品列表使用
 */
@property (nonatomic, strong) ECPointProductListModel *pointModel;

//是否可删除
@property (nonatomic, assign) BOOL isDelete;
//点击删除的回调
@property (nonatomic, copy) void (^deleteBlock)(NSString *collectID,NSInteger row);

@end
