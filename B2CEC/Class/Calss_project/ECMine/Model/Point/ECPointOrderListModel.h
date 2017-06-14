//
//  ECPointOrderListModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECPointOrderDetailInfoModel;

@interface ECPointOrderListModel : NSObject

/**
 订单id 兑换记录id
 */
@property (nonatomic, copy) NSString *orderIds;
/**
 订单号
 */
@property (nonatomic, copy) NSString *orderNo;
/**
 交易号
 */
@property (nonatomic, copy) NSString *tradeNo;
/**
 商品名
 */
@property (nonatomic, copy) NSString *name;
/**
 积分总额
 */
@property (nonatomic, copy) NSString *point;
/**
 下单时间
 */
@property (nonatomic, copy) NSString *createDate;
/**
 图片
 */
@property (nonatomic, copy) NSString *image;

- (instancetype)initWithECPointOrderDetailInfoModel:(ECPointOrderDetailInfoModel *)model;


@end
