//
//  ECConfirmOrderViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"


/**
 提交订单的方式

 - ConfirmOrderType_buyNow: 立即购买
 - ConfirmOrderType_cartCommit: 购物车提交订单
 */
typedef NS_ENUM(NSInteger, ConfirmOrderType) {
    ConfirmOrderType_buyNow,
    ConfirmOrderType_cartCommit
};

@class ECCartFactoryModel;

@interface ECConfirmOrderViewController : CMBaseViewController

/**
 是否是购买尾货，非必须，仅在立即购买时需要，必须在dataSource之前set
 */
@property (nonatomic, assign) BOOL isLeftProduct;
/**
 是否是抢购，非必须，仅在立即购买时需要，必须在dataSource之前set
 */
@property (nonatomic, assign) BOOL isPanicBuy;
/**
 数据源，必须
 */
@property (nonatomic, strong) NSMutableArray <ECCartFactoryModel *> *dataSource;
/**
 提交订单的方式，必须
 */
@property (nonatomic, assign) ConfirmOrderType confirmType;

@end
