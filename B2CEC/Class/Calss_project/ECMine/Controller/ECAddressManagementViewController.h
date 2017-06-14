//
//  ECAddressManagementViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"
#import "ECAddressModel.h"

@interface ECAddressManagementViewController : CMBaseTableViewController

@property (nonatomic, copy) void(^needReloadDataInSuperVCCallBack)(NSMutableArray *dataSource);

@end
