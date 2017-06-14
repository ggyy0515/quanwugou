//
//  ECOrderDetailBottomView.h
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECOrderListModel;

@interface ECOrderDetailBottomView : UIView

@property (nonatomic, copy) void(^clickActionBtn)(NSString *title);

@property (nonatomic, strong) ECOrderListModel *model;

@end
