//
//  ECMallPanicBuyProductModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMallPanicBuyProductModel : NSObject

/**
 ids
 */
@property (nonatomic, copy) NSString *ids;
/**
 商品名
 */
@property (nonatomic, copy) NSString *proName;
/**
 价格
 */
@property (nonatomic, copy) NSString *price;
/**
 口号
 */
@property (nonatomic, copy) NSString *slogan;
/**
 表名
 */
@property (nonatomic, copy) NSString *proTable;
/**
 商品id
 */
@property (nonatomic, copy) NSString *proId;
/**
 开始时间
 */
@property (nonatomic, copy) NSString *startTimeStr;
/**
 活动类型
 */
@property (nonatomic, copy) NSString *activeType;
/**
 结束时间
 */
@property (nonatomic, copy) NSString *endTimeStr;
/**
 排序
 */
@property (nonatomic, copy) NSString *sort;
/**
 图片
 */
@property (nonatomic, copy) NSString *image;
/**
 原件
 */
@property (nonatomic, copy) NSString *originPrice;

@end
