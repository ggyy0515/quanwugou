//
//  ECProductInfoModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECProductInfoModel : NSObject

/**
 产品系列
 */
@property (nonatomic, copy) NSString *serise;

/**
 产品是否打折。0-可打折 1-不可打折  是否是VIP
 */
@property (nonatomic, copy) NSString *isDiscount;

/**
 产品ID
 */
@property (nonatomic, copy) NSString *proId;

/**
 产品表名
 */
@property (nonatomic, copy) NSString *proTable;

/**
 产品名称
 */
@property (nonatomic, copy) NSString *name;

/**
 产品生产周期
 */
@property (nonatomic, copy) NSString *period;

/**
 产品销量
 */
@property (nonatomic, copy) NSString *saleNumber;

/**
 产品是否收藏 0 是未收藏，1是已收藏
 */
@property (nonatomic, copy) NSString *isCollect;

/**
 产品积分
 */
@property (nonatomic, copy) NSString *point;

/**
 产品售价
 */
@property (nonatomic, copy) NSString *price;
/**
 是否分期:0-不分期,1-分期
 */
@property (nonatomic, copy) NSString *isEasePay;
/**
 产地
 */
@property (nonatomic, copy) NSString *area;
/**
 评论数量
 */
@property (nonatomic, copy) NSString *appraiseNum;
/**
 库存
 */
@property (nonatomic, copy) NSString *stock;
/**
 剩余秒数
 */
@property (nonatomic, assign) NSInteger leftSecond;
/**
 是否是限时抢购商品0-否,1-是,
 */
@property (nonatomic, copy) NSString *isPanicBuy;
/**
 活动价格 仅在抢购时候使用
 */
@property (nonatomic, copy) NSString *actPrice;
/**
 是否是尾货:0-是,1-否
 */
@property (nonatomic, copy) NSString *isLeftProduct;
/**
 工厂id（工厂环信）
 */
@property (nonatomic, copy) NSString *factoryUserId;


/**
 *  剩余时间-1
 */
- (void)countDown;

/**
 *  获取用于展示的当前剩余时间
 *
 *  @return string对象
 */
- (NSString *)currentTimeString;

- (NSString *)getDay;

- (NSString *)getHour;

- (NSString *)getMinute;

- (NSString *)getSecond;


@end
