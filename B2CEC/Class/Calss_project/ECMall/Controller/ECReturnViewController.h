//
//  ECReturnViewController.h
//  B2CEC
//
//  Created by 曙华 on 16/7/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"


typedef NS_ENUM(NSInteger, ECReturnViewControllerType) {
    ECReturnViewControllerReturn,         // 退货申请
    ECReturnViewControllerExchange        // 换货申请
    
};


@interface ECReturnViewController : CMBaseViewController


@property (nonatomic, assign) ECReturnViewControllerType selectType;
/**
 *  订单ID
 */
@property (nonatomic, copy) NSString *orderId;


/*!
 *  回调
 */
@property (copy,nonatomic) void (^changeStateBlock)();

@end
