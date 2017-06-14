//
//  ECFocusAndFansViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"

@interface ECFocusAndFansViewController : CMBaseTableViewController
//0 : focus  1：fans
@property (assign,nonatomic) NSInteger type;

@property (strong,nonatomic) NSString *userID;

@end
