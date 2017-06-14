//
//  UITextField+ActionBlock.h
//  ZhongShanEC
//
//  Created by shuhua on 16/1/7.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UITextFieldActionBlock)(UITextField *sender);

@interface UITextField (ActionBlock)

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(UITextFieldActionBlock)actionBlock;

@end
