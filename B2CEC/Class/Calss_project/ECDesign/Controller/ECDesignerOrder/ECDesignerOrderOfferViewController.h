//
//  ECDesignerOrderOfferViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@interface ECDesignerOrderOfferViewController : CMBaseViewController

+ (void)showOfferVCInSuperViewController:(UIViewController *)superVC verifyResultBlock:(void(^)(CGFloat money))verifyResultBlock;

@end
