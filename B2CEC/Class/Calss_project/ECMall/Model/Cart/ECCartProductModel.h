//
//  ECCartProductModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECCartProductModel : NSObject
<
    NSMutableCopying
>



/**
 表名
 */
@property (nonatomic, copy) NSString *protable;
/**
 积分
 */
@property (nonatomic, copy) NSString *point;
/**
 分期支付尾款
 */
@property (nonatomic, copy) NSString *leftPay;
/**
 图片
 */
@property (nonatomic, copy) NSString *image;
/**
 全额支付的金额
 */
@property (nonatomic, copy) NSString *price;
/**
 商品id
 */
@property (nonatomic, copy) NSString *proId;
/**
 分期支付的定金
 */
@property (nonatomic, copy) NSString *nowPay;
/**
 库存
 */
@property (nonatomic, copy) NSString *stock;
/**
 是否支持分期:0-不分期,1-分期
 */
@property (nonatomic, copy) NSString *isEasyPay;
/**
 生产周期
 */
@property (nonatomic, copy) NSString *period;
/**
 vip分期支付的定金
 */
@property (nonatomic, copy) NSString *nowVipPay;
/**
 商品名
 */
@property (nonatomic, copy) NSString *name;
/**
 vip分期支付的尾款
 */
@property (nonatomic, copy) NSString *leftVipPay;
/**
 vip全额支付全款
 */
@property (nonatomic, copy) NSString *vipPrice;
/**
 商品数量
 */
@property (nonatomic, copy) NSString *count;
/**
 购物车id
 */
@property (nonatomic, copy) NSString *cartId;
/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelectet;
/**
 是否使用Q码
 */
@property (nonatomic, assign) BOOL useQcode;
/**
 是否使用分期
 */
@property (nonatomic, assign) BOOL useEasyPay;



@end
