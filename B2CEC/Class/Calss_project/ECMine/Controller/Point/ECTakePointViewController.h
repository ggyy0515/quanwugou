//
//  ECTakePointViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/12/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@class ECPointInfoModel;

@interface ECTakePointViewController : CMBaseViewController

- (instancetype)initWithPointInfoModel:(ECPointInfoModel *)model;

@end
