//
//  ECPointProductDetailInfoModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECPointProductDetailInfoModel : NSObject

/**
 商品id
 */
@property (nonatomic, copy) NSString *ids;
/**
 积分
 */
@property (nonatomic, copy) NSString *point;
/**
 库存
 */
@property (nonatomic, copy) NSString *stock;
/**
 商品名
 */
@property (nonatomic, copy) NSString *name;
/**
 详情H5代码
 */
@property (nonatomic, copy) NSString *detail;


@end
