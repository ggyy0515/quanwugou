//
//  ECBankListViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@class ECBankListModel;

@interface ECBankListViewController : CMBaseViewController

@property (nonatomic, copy) void(^didSelectBank)(ECBankListModel *model);

@end
