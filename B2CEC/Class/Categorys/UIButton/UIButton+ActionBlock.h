//
//  UIButton+ActionBlock.h
//  TrCommerce
//
//  Created by Tristan on 15/11/18.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef void (^ActionBlock)(UIButton *sender);

@interface UIButton (ActionBlock)

- (void) yyhandleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

@end
