//
//  ECMallPanicBuyListModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMallPanicBuyListModel : NSObject
/**
 id
 */
@property (nonatomic, copy) NSString *ids;
/**
 口号
 */
@property (nonatomic, copy) NSString *slogan;
/**
 图片
 */
@property (nonatomic, copy) NSString *image;
/**
 表名
 */
@property (nonatomic, copy) NSString *proTable;
/**
 活动类型
 */
@property (nonatomic, copy) NSString *activeType;
/**
 结束时间
 */
@property (nonatomic, copy) NSString *endTime;
/**
 原价
 */
@property (nonatomic, copy) NSString *originPrice;
/**
 开始时间
 */
@property (nonatomic, copy) NSString *startTime;
/**
 商品id
 */
@property (nonatomic, copy) NSString *proId;
/**
 商品名
 */
@property (nonatomic, copy) NSString *name;
/**
 价格
 */
@property (nonatomic, copy) NSString *price;
/**
 剩余秒数
 */
@property (nonatomic, assign) NSInteger leftSecond;

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


@end
