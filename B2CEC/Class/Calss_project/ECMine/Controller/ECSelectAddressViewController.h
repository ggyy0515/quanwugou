//
//  ECSelectAddressViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"
#import "ECAddressModel.h"

@interface ECSelectAddressViewController : CMBaseTableViewController
/**
 当前选中的地址ID，如果不传则表示采用默认地址
 */
@property (strong,nonatomic) NSString *addressID;

@property (copy,nonatomic) void (^selectAddressBlock)(ECAddressModel *model);

@end
