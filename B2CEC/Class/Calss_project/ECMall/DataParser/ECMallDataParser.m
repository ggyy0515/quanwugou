//
//  ECMallDataParser.m
//  B2CEC
//
//  Created by Tristan on 2016/11/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallDataParser.h"
#import "ECMallTagModel.h"
#import "ECMallCycleViewModel.h"
#import "ECMallHouseModel.h"
#import "ECMallPanicBuyProductModel.h"
#import "ECMallFloorModel.h"
#import "ECMallFloorProductModel.h"

@implementation ECMallDataParser

+ (void)loadMallIndexDataSourcesSucceed:(void(^)(NSMutableArray <ECMallTagModel *> *mallTagDataSource,
                                                 NSMutableArray <ECMallCycleViewModel *> *mallCycleDataSource,
                                                 NSMutableArray <ECMallHouseModel *> *mallHouseDataSource,
                                                 NSMutableArray <ECMallPanicBuyProductModel *> *panicBuyDataSource,
                                                 NSMutableArray <ECMallFloorModel *> *mallFloorDataSource))succeed
                                 failed:(void(^)())falied {
    [ECHTTPServer requestMallIndexInfoWithCity:[CMLocationManager sharedCMLocationManager].userCityName
                                       succeed:^(NSURLSessionDataTask *task, id result) {
                                           ECLog(@"%@", result);
                                           if (IS_REQUEST_SUCCEED(result)) {
                                               //请求成功，开始解析首页数据
                                               //顶部分类数据解析
                                               NSMutableArray *mallTagDataSource = [NSMutableArray array];
                                               ECMallTagModel *allModel = [[ECMallTagModel alloc] init];
                                               allModel.name = @"全部";
                                               allModel.code = @"";
                                               allModel.isSel = YES;
                                               [mallTagDataSource addObject:allModel];
                                               [result[@"topclassify"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                   ECMallTagModel *model = [ECMallTagModel yy_modelWithDictionary:dic];
                                                   model.isSel = NO;
                                                   [mallTagDataSource addObject:model];
                                               }];
                                               //轮播图数据解析
                                               NSMutableArray *mallCycleDataSource = [NSMutableArray array];
                                               [result[@"indexshow"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                   ECMallCycleViewModel *model = [ECMallCycleViewModel yy_modelWithDictionary:dic];
                                                   [mallCycleDataSource addObject:model];
                                               }];
                                               //馆数据解析
                                               NSMutableArray *mallHouseDataSource = [NSMutableArray array];
                                               [result[@"productHall"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                   ECMallHouseModel *model = [ECMallHouseModel yy_modelWithDictionary:dic];
                                                   [mallHouseDataSource addObject:model];
                                               }];
                                               //抢购数据解析
                                               NSMutableArray *panicBuyDataSource = [NSMutableArray array];
                                               [result[@"qianggouList"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                   ECMallPanicBuyProductModel *model = [ECMallPanicBuyProductModel yy_modelWithDictionary:dic];
                                                   [panicBuyDataSource addObject:model];
                                               }];
                                               //楼层数据解析
                                               NSMutableArray *mallFloorDataSource = [NSMutableArray array];
                                               [result[@"listFloor"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                   ECMallFloorModel *model = [ECMallFloorModel yy_modelWithDictionary:dic];
                                                   [mallFloorDataSource addObject:model];
                                               }];
                                               succeed(mallTagDataSource,
                                                       mallCycleDataSource,
                                                       mallHouseDataSource,
                                                       panicBuyDataSource,
                                                       mallFloorDataSource);
                                               
                                           } else {
                                               EC_SHOW_REQUEST_ERROR_INFO
                                               falied();
                                           }
                                       }
                                        failed:^(NSURLSessionDataTask *task, NSError *error) {
                                            RequestFailure
                                            falied();
                                        }];
}

+ (void)loadProductFiltrateWithHouseCode:(NSString *)houseCode
                                 catCode:(NSString *)catCode
                               WithBlock:(void(^)(BOOL isSucceed))completeBlock {
    [ECHTTPServer requestFilterDataWithHouseCode:houseCode
                                         catCode:catCode
                                         succeed:^(NSURLSessionDataTask *task, id result) {
                                             if (IS_REQUEST_SUCCEED(result)) {
                                                 NSMutableDictionary *dict = UnarchiveSearchCondition;
                                                 if (dict == nil) {
                                                     dict = [NSMutableDictionary new];
                                                 }
                                                 //由于从场馆进入筛选和分类进入筛选所取得的条件不一样 这里以houseCode和catCode的组合来确定key
                                                 [dict setObject:result[@"filt"] forKey:[NSString stringWithFormat:@"%@%@", houseCode, catCode]];
                                                 RearchiverSearchCondition(dict);
                                                      completeBlock(YES);
                                                 DISMISSSVP
                                             }else{
                                                 completeBlock(NO);
                                                 EC_SHOW_REQUEST_ERROR_INFO
                                             }
                                         }
                                          failed:^(NSURLSessionDataTask *task, NSError *error) {
                                             RequestFailure
                                          }];
}

/*
 待付款：  For_the_payment
 （待接单： daijiedan
 工厂接单： gongchangjiedan
 生产完成：shengchanwancheng
 待付尾款：daifuweikuan）
 
 
 待发货：   To_send_the_goods
 待收货：   For_the_goods
 待评价：  For_the_Comment
 完成：  Complete
 退货：  Return
 (已退货： Have_To_Return
 退货中： In_Return)
 
 
 订单已取消：Cancel
 */

+ (NSString *)getOrderStateTitleWithMainStateString:(NSString *)mainStateString subStateString:(NSString *)subStateString {
    if ([mainStateString isEqualToString:@"For_the_payment"]) {
        if ([subStateString isEqualToString:@"daijiedan"]) {
            return @"待接单";
        }
        else if ([subStateString isEqualToString:@"gongchangjiedan"]) {
            //工厂接单
            return @"生产中";
        }
        else if ([subStateString isEqualToString:@"shengchanwancheng"]) {
            return @"生产完成";
        }
        else if ([subStateString isEqualToString:@"daifuweikuan"]) {
            return @"待付尾款";
        }
        else {
            return @"待付款";
        }
    }
    
    else if ([mainStateString isEqualToString:@"To_send_the_goods"]) {
        return @"待发货";
    }
    else if ([mainStateString isEqualToString:@"For_the_goods"]) {
        return @"待收货";
    }
    else if ([mainStateString isEqualToString:@"For_the_Comment"]) {
        return @"待评价";
    }
    else if ([mainStateString isEqualToString:@"Return"]) {
        if ([subStateString isEqualToString:@"In_Return"]) {
            return @"退货中";
        }
        else {
            return @"已退货";
        }
    }
    else if ([mainStateString isEqualToString:@"Complete"]) {
        return @"交易完成";
    }
    else {
        return @"交易取消";
    }
    
}

@end
