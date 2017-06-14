//
//  ECMallDataParser.h
//  B2CEC
//
//  Created by Tristan on 2016/11/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECMallTagModel;
@class ECMallCycleViewModel;
@class ECMallHouseModel;
@class ECMallPanicBuyProductModel;
@class ECMallFloorModel;
@class ECMallFloorProductModel;

@interface ECMallDataParser : NSObject

+ (void)loadMallIndexDataSourcesSucceed:(void(^)(NSMutableArray <ECMallTagModel *> *mallTagDataSource,
                                                 NSMutableArray <ECMallCycleViewModel *> *mallCycleDataSource,
                                                 NSMutableArray <ECMallHouseModel *> *mallHouseDataSource,
                                                 NSMutableArray <ECMallPanicBuyProductModel *> *panicBuyDataSource,
                                                 NSMutableArray <ECMallFloorModel *> *mallFloorDataSource))succeed
                                 failed:(void(^)())falied;


+ (void)loadProductFiltrateWithHouseCode:(NSString *)houseCode
                                 catCode:(NSString *)catCode
                               WithBlock:(void(^)(BOOL isSucceed))completeBlock;


/**
 根据订单状态字符串获取状态title

 @param mainStateString 订单主状态字符串
 @param subStateString 订单子状态字符串
 @return <#return value description#>
 */
+ (NSString *)getOrderStateTitleWithMainStateString:(NSString *)mainStateString subStateString:(NSString *)subStateString;

@end
