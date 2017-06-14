//
//  ECPlaceOrderViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"
#import "ECPlaceOrderModel.h"

@interface ECPlaceOrderViewController : CMBaseTableViewController

@property (strong,nonatomic) ECPlaceOrderModel *orderModel;

@property (strong,nonatomic) NSString *designerName;

@property (strong,nonatomic) NSString *designerTitleImage;

@property (assign,nonatomic) BOOL isUpdate;

@property (copy,nonatomic) void (^submitSuccessBlock)();

@end
