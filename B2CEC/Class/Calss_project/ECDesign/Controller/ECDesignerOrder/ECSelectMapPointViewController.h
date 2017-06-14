//
//  ECSelectMapPointViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@interface ECSelectMapPointViewController : CMBaseViewController

@property (nonatomic, copy) void(^didSelectMapPoint)(double latitude, double longitude);

@end
