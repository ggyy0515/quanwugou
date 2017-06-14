//
//  ECPointInfoModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECPointInfoModel : NSObject

/**
 冻结积分
 */
@property (nonatomic, copy) NSString *frozenPoint;
/**
 积分汇总表是否有变化:0-没有变化,1-有变化
 */
@property (nonatomic, copy) NSString *hasChange;
/**
 主键
 */
@property (nonatomic, copy) NSString *ids;
/**
 总积分
 */
@property (nonatomic, copy) NSString *totalPoint;
/**
 可用积分
 */
@property (nonatomic, copy) NSString *point;
/**
 积分兑现比例
 */
@property (nonatomic, copy) NSString *rate;


@end
