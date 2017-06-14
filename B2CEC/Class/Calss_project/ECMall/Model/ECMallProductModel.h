//
//  ECMallProductModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMallProductModel : NSObject

/**
 商品id
 */
@property (nonatomic, copy) NSString *proId;
/**
 图片
 */
@property (nonatomic, copy) NSString *image;
/**
 商品名
 */
@property (nonatomic, copy) NSString *name;
/**
 价格
 */
@property (nonatomic, copy) NSString *price;
/**
 表名
 */
@property (nonatomic, copy) NSString *protable;

/**
 收藏列表才会产生的收藏ID
 */
@property (nonatomic, copy) NSString *collect_id;

@end
