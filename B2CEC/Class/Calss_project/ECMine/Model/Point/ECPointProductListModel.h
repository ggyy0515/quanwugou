//
//  ECPointProductListModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECPointProductListModel : NSObject

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
 所需积分
 */
@property (nonatomic, copy) NSString *point;

@end
