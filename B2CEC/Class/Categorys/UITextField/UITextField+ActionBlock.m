	//
//  UITextField+ActionBlock.m
//  ZhongShanEC
//
//  Created by shuhua on 16/1/7.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import "UITextField+ActionBlock.h"
#import <objc/runtime.h>

static char * kUITextFieldActionBlockIdentifier = "kUITextFieldActionBlockIdentifier";

@implementation UITextField (ActionBlock)

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(UITextFieldActionBlock)actionBlock
{
    objc_setAssociatedObject(self, &kUITextFieldActionBlockIdentifier, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(textFieldAction:) forControlEvents:controlEvent];
}

- (void)textFieldAction:(UITextField *)sender
{
    UITextFieldActionBlock actionBlock = objc_getAssociatedObject(self, &kUITextFieldActionBlockIdentifier);
    if (actionBlock) {
        actionBlock(sender);
    }
}

@end
