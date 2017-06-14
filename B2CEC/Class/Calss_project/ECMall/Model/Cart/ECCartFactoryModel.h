//
//  ECCartFactoryModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECCartProductModel;

@interface ECCartFactoryModel : NSObject
<
    NSMutableCopying
>

/**
 工厂名称
 */
@property (nonatomic, copy) NSString *seller;
/**
 在该工厂购买的商品总件数
 */
@property (nonatomic, copy) NSString *productCount;
/**
 商品列表
 */
@property (nonatomic, strong) NSMutableArray <ECCartProductModel *> *productList;
/**
 卖家id
 */
@property (nonatomic, copy) NSString *sellerId;
/**
 给卖家留言，用于提交订单
 */
@property (nonatomic, copy) NSString *message;

@end
