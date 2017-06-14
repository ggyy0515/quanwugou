//
//  ECReportViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2017/1/17.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@interface ECReportViewController : CMBaseViewController

+ (void)showReportVCInSuperViewController:(UIViewController *)superVC verifyResultBlock:(void(^)(NSString *type,NSString *content))verifyResultBlock;


@end
