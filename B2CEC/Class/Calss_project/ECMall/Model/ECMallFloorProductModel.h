//
//  ECMallFloorProductModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMallFloorProductModel : NSObject

/**
 口号
 */
@property (nonatomic, copy) NSString *slogan;
/**
 排序
 */
@property (nonatomic, copy) NSString *sort;
/**
 图片
 */
@property (nonatomic, copy) NSString *image;
/**
 ids
 */
@property (nonatomic, copy) NSString *ids;
/**
 商品ids
 */
@property (nonatomic, copy) NSString *proId;
/**
 楼层id
 */
@property (nonatomic, copy) NSString *floorId;
/**
 表名
 */
@property (nonatomic, copy) NSString *proTable;
/**
 商品名
 */
@property (nonatomic, copy) NSString *proName;
/**
 价格
 */
@property (nonatomic, copy) NSString *price;

@end
