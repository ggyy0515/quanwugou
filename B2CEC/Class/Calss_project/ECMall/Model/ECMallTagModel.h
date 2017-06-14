//
//  ECMallTagModel.h
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMallTagModel : NSObject
/**
 分类名
 */
@property (nonatomic, copy) NSString *name;
/**
 编码
 */
@property (nonatomic, copy) NSString *code;
/**
 选择状态
 */
@property (nonatomic, assign)BOOL isSel;

@end
