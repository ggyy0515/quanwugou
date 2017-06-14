//
//  ECConfirmOrderBottomView.h
//  B2CEC
//
//  Created by Tristan on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECConfirmOrderBottomView : UIView

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, copy) void(^clickPayBtn)();

@end
