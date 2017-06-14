//
//  ECPointOrderDetailInfoModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECPointOrderDetailInfoModel : NSObject

/**
 订单号
 */
@property (nonatomic, copy) NSString *orderNo;
/**
 交易流水号
 */
@property (nonatomic, copy) NSString *tradeNo;
/**
 积分
 */
@property (nonatomic, copy) NSString *point;
/**
 交易人
 */
@property (nonatomic, copy) NSString *userName;
/**
 联系电话
 */
@property (nonatomic, copy) NSString *mobile;
/**
 收件人
 */
@property (nonatomic, copy) NSString *receiver;
/**
 邮寄地址
 */
@property (nonatomic, copy) NSString *address;
/**
 快递公司
 */
@property (nonatomic, copy) NSString *express;
/**
 物流单号
 */
@property (nonatomic, copy) NSString *expressNumber;
/**
 状态：0-待发货；1-已发货
 */
@property (nonatomic, copy) NSString *state;
/**
 交易时间
 */
@property (nonatomic, copy) NSString *createDate;
/**
 订单留言
 */
@property (nonatomic, copy) NSString *message;
/**
 商品名称
 */
@property (nonatomic, copy) NSString *proName;
/**
 商品数量
 */
@property (nonatomic, copy) NSString *count;
/**
 快递公司编码
 */
@property (nonatomic, copy) NSString *expressCode;
/**
 订单id
 */
@property (nonatomic, copy) NSString *orderId;
/**
 商品图片
 */
@property (nonatomic, copy) NSString *image;




@end
