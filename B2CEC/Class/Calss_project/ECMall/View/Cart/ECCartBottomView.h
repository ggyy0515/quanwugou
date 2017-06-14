//
//  ECCartBottomView.h
//  B2CEC
//
//  Created by Tristan on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECCartBottomView : UIView

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) CGFloat price;
/**
 点击全选按钮
 */
@property (nonatomic, copy) void(^clickAllBtn)(BOOL selectAll);
/**
 点击删除按钮
 */
@property (nonatomic, copy) void(^clickDeleteBtn)();
/**
 点击结算按钮
 */
@property (nonatomic, copy) void(^clickOrderBtn)();
/**
 点击转到收藏按钮
 */
@property (nonatomic, copy) void(^clickCollectBtn)();

@end
