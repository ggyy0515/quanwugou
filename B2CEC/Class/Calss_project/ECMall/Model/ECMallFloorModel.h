//
//  ECMallFloorModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECMallFloorProductModel;

@interface ECMallFloorModel : NSObject

/**
 楼层排序
 */
@property (nonatomic, copy) NSString *floorSort;
/**
 楼层图片
 */
@property (nonatomic, copy) NSString *image;
/**
 楼层ids
 */
@property (nonatomic, copy) NSString *ids;
/**
 楼层名字
 */
@property (nonatomic, copy) NSString *floorName;
/**
 楼层商品
 */
@property (nonatomic, copy) NSArray <ECMallFloorProductModel *> *productList;
/**
 品牌
 */
@property (nonatomic, copy) NSString *brand;
/**
 分类筛选的code
 */
@property (nonatomic, copy) NSString *attrCode;
/**
 分类筛选的value
 */
@property (nonatomic, copy) NSString *attrValue;
/**
 编码（对应分类编码）
 */
@property (nonatomic, copy) NSString *code;


@end
