//
//  ECAdvertisingViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@interface ECAdvertisingViewController : CMBaseViewController

@property (strong,nonatomic) NSString *url;

@property (assign,nonatomic) BOOL isHavRightNav;

@property (copy,nonatomic) void (^rightNavClickBlock)();

@end
