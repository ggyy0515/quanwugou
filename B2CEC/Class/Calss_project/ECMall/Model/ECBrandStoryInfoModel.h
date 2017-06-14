//
//  ECBrandStoryInfoModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECBrandStoryInfoModel : NSObject

/**
 h5内容  正文显示内容
 */
@property (nonatomic, copy) NSString *content;
/**
 宣传语句
 */
@property (nonatomic, copy) NSString *slogan;
/**
 品牌商名称
 */
@property (nonatomic, copy) NSString *name;
/**
 logo图片
 */
@property (nonatomic, copy) NSString *image;
/**
 联系电话
 */
@property (nonatomic, copy) NSString *telephone;

@end
