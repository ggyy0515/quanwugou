//
//  ECPublicDataModel+CoreDataProperties.h
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "ECPublicDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ECPublicDataModel (CoreDataProperties)

+ (NSFetchRequest<ECPublicDataModel *> *)fetchRequest;

/**
 热线电话
 */
@property (nullable, nonatomic, copy) NSString *hotline;
/**
 环信客服账号
 */
@property (nullable, nonatomic, copy) NSString *hotlineId;
/**
 图片url前缀
 */
@property (nullable, nonatomic, copy) NSString *imageHeader;
/**
 基础参数更新时间
 */
@property (nonatomic) int64_t timeStamp;
/**
 资讯分享的url  param1:编码,param2:资讯的ID
 */
@property (nullable, nonatomic, copy) NSString *informationShareUrl;
/**
 商品分享的ur  param1：商品的表名，param2：商品的ID
 */
@property (nullable, nonatomic, copy) NSString *productShareUrl;
/**
 案例的分享url  param1：案例的ID
 */
@property (nullable, nonatomic, copy) NSString *caseShareUrl;

@end

NS_ASSUME_NONNULL_END
