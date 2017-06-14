//
//  ECPointManagmentBillModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECPointManagmentBillModel : NSObject

/**
 时间
 */
@property (nonatomic, copy) NSString *createDate;
/**
 ids
 */
@property (nonatomic, copy) NSString *ids;
/**
 积分来源：0-购买商品获得积分，1-活动，2-二线，3-三线 , 4-积分的兑现5-积分的兑换产品
 */
@property (nonatomic, copy) NSString *source;
/**
 描述
 */
@property (nonatomic, copy) NSString *detail;
/**
 积分
 */
@property (nonatomic, copy) NSString *point;
/**
 带符号的积分
 */
@property (nonatomic, copy) NSString *symbolPoint;
/**
 图片
 */
@property (nonatomic, copy) NSString *image;



@end
