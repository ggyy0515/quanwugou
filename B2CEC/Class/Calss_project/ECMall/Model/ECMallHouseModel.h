//
//  ECMallHouseModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMallHouseModel : NSObject

/**
 名称
 */
@property (nonatomic, copy) NSString *name;
/**
 编码
 */
@property (nonatomic, copy) NSString *code;
/**
 图标
 */
@property (nonatomic, copy) NSString *image;
/**
 排序顺序
 */
@property (nonatomic, copy) NSString *orderBy;

@end
