//
//  ECDesignerOrderDetailViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"

@interface ECDesignerOrderDetailViewController : CMBaseTableViewController

@property (assign,nonatomic) BOOL isDesigner;

@property (strong,nonatomic) NSString *orderid;

@property (copy,nonatomic) void (^updateSuccessBlock)();

@end
