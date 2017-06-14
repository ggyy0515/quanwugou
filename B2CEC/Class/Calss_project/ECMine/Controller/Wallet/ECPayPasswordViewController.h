//
//  ECPayPasswordViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/12/16.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@interface ECPayPasswordViewController : CMBaseViewController

/**
 构造并展示支付密码输入器,同时回调验证结果,验证成功后带菊花

 @param superVC superVC
 @param amount 金额，需要符号自己加
 @param verifyResultBlock 验证结果回调
 */
+ (void)showPayPasswordVCInSuperViewController:(UIViewController *)superVC amount:(NSString *)amount verifyResultBlock:(void(^)(BOOL isPasswordValid))verifyResultBlock;

@end
