//
//  ECOrderProductModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECOrderProductModel : NSObject
/**
 金额(在订单中的价格)
 */
@property (nonatomic, copy) NSString *amount;
/**
 图片
 */
@property (nonatomic, copy) NSString *image;
/**
 订单id
 */
@property (nonatomic, copy) NSString *orderId;
/**
 商品单价
 */
@property (nonatomic, copy) NSString *price;
/**
 商品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 数量
 */
@property (nonatomic, copy) NSString *count;
/**
 商品ID
 */
@property (nonatomic, copy) NSString *proId;
/**
 商品表名
 */
@property (nonatomic, copy) NSString *protable;
/**
 尾款
 */
@property (nonatomic, copy) NSString *leftpay;
/**
 订单详情表ID
 */
@property (nonatomic, copy) NSString *orderDetailId;
/**
 已经支付
 */
@property (nonatomic, copy) NSString *nowPay;
/**
 是否是分期支付0-是1-否
 */
@property (nonatomic, copy) NSString *isEasyPay;


@end
