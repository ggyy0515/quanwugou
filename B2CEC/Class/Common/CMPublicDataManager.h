//
//  CMPublicDataManager.h
//  B2CEC
//
//  Created by Tristan on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECPublicDataModel+CoreDataClass.h"

@class ECMallTagModel;

@interface CMPublicDataManager : NSObject

singleton_interface(CMPublicDataManager)

@property (nonatomic, strong) ECPublicDataModel *publicDataModel;

/**
 商城首页分类的数据源，保留内存缓存
 */
@property (nonatomic, strong) NSMutableArray *mallTagDataSource;

/**
 购物车数量，保留内存缓存
 */
@property (nonatomic, assign) NSInteger cartNumber;

- (void)loadPublicDataFromNetwork:(void(^)())completeBlock;

@end
