//
//  ECBindMobileViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"

@interface ECBindMobileViewController : CMBaseTableViewController

@property (strong,nonatomic) UMSocialUserInfoResponse *userinfo;

@property (assign,nonatomic) UMSocialPlatformType type;

@end