//
//  ECPointConfirmOrderBottomView.h
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECPointConfirmOrderBottomView : UIView

@property (nonatomic, assign) CGFloat point;

@property (nonatomic, copy) void(^clickPayBtn)();

@end
