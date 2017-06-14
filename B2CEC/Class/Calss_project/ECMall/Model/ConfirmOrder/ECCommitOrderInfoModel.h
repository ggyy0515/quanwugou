//
//  ECCommitOrderInfoModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECCommitOrderInfoModel : NSObject

/**
 订单号列表
 */
@property (nonatomic, copy) NSArray <NSString *> *orderNumbers;
/**
 总价(含尾款)
 */
@property (nonatomic, copy) NSString *totalPrice;
/**
 尾款
 */
@property (nonatomic, copy) NSString *leftPay;
/**
 当前需要支付的钱
 */
@property (nonatomic, copy) NSString *nowPay;
/**
 类型:nowpay-订单支付,leftpay-尾款支付,designpay-设计订单支付
 */
@property (nonatomic, copy) NSString *type;

@end
