//
//  ECBankListModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECBankListModel : NSObject

/**
 id
 */
@property (nonatomic, copy) NSString *ids;
/**
 编码
 */
@property (nonatomic, copy) NSString *code;
/**
 名称
 */
@property (nonatomic, copy) NSString *name;
/**
 图标
 */
@property (nonatomic, copy) NSString *image;

@end
