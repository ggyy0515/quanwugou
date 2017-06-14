//
//  ECCommentOrderViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@class ECOrderListModel;

@interface ECCommentOrderViewController : CMBaseViewController

- (instancetype)initWithOrderList:(ECOrderListModel *)model;

@end
