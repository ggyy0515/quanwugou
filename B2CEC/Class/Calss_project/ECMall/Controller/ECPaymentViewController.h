//
//  ECPaymentViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@class ECCommitOrderInfoModel;

@interface ECPaymentViewController : CMBaseViewController

- (instancetype)initWithPopClass:(Class)cls;

/**
 生成订单时返回的数据模型（必须）
 */
@property (nonatomic, strong) ECCommitOrderInfoModel *model;

@end
