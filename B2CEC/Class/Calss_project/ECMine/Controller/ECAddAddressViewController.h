//
//  ECAddAddressViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"
#import "ECAddressModel.h"

@interface ECAddAddressViewController : CMBaseTableViewController
//如果传该值，表示当前是修改地址
@property (strong,nonatomic) ECAddressModel *model;

@property (copy,nonatomic) void (^addAddressBlock)();

@end
