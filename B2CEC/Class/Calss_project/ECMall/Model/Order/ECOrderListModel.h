//
//  ECOrderListModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECOrderProductModel;

@interface ECOrderListModel : NSObject
/**
 收货人
 */
@property (nonatomic, copy) NSString *receiver;
/**
 交易号
 */
@property (nonatomic, copy) NSString *tranNo;
/**
 订单状态
 */
@property (nonatomic, copy) NSString *state;
/**
 订单id
 */
@property (nonatomic, copy) NSString *orderId;
/**
 物流公司
 */
@property (nonatomic, copy) NSString *express;
/**
 已支付金额
 */
@property (nonatomic, copy) NSString *nowPay;
/**
 收货地址-市
 */
@property (nonatomic, copy) NSString *city;
/**
 退款批次号
 */
@property (nonatomic, copy) NSString *batchNo;
/**
 物流编码
 */
@property (nonatomic, copy) NSString *expressCode;
/**
 收货地址-省
 */
@property (nonatomic, copy) NSString *province;
/**
 应付总金额,
 */
@property (nonatomic, copy) NSString *totalMoney;
/**
 是否删除0-否1-是
 */
@property (nonatomic, copy) NSString *isDel;
/**
 用户ID
 */
@property (nonatomic, copy) NSString *userId;
/**
 生成订单时间
 */
@property (nonatomic, copy) NSString *createTime;
/**
 修改人
 */
@property (nonatomic, copy) NSString *updateBy;
/**
 支付方式
 */
@property (nonatomic, copy) NSString *payWay;
/**
 不知道是什么鬼
 */
@property (nonatomic, copy) NSString *iswxjspay;
/**
 修改时间
 */
@property (nonatomic, copy) NSString *updateTime;
/**
 备注消息
 */
@property (nonatomic, copy) NSString *message;
/**
 订单子状态
 */
@property (nonatomic, copy) NSString *subState;
/**
 Q码
 */
@property (nonatomic, copy) NSString *qCode;
/**
 订单号
 */
@property (nonatomic, copy) NSString *orderNo;
/**
 收货详情地址
 */
@property (nonatomic, copy) NSString *address;
/**
 尾款
 */
@property (nonatomic, copy) NSString *leftPay;
/**
 商品列表
 */
@property (nonatomic, copy) NSArray <ECOrderProductModel *> *productList;
/**
 商家(工厂)ID
 */
@property (nonatomic, copy) NSString *sellerId;
/**
 发票抬头
 */
@property (nonatomic, copy) NSString *billTitle;
/**
 物流单号
 */
@property (nonatomic, copy) NSString *expressNumber;
/**
 支付时间
 */
@property (nonatomic, copy) NSString *payTime;
/**
 收货人联系方式
 */
@property (nonatomic, copy) NSString *mobile;
/**
 是否可以退货(0-可以 1-不可以退)
 */
@property (nonatomic, copy) NSString *canReturn;
/**
 优惠金额
 */
@property (nonatomic, copy) NSString *disCountMoney;

@end
