//
//  UIButton+ActionBlock.m
//  TrCommerce
//
//  Created by Tristan on 15/11/18.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "UIButton+ActionBlock.h"

@interface UIButton ()

@property (nonatomic, copy) ActionBlock action;

@end


@implementation UIButton (ActionBlock)


static char yyActionBlockKey;


- (void)yyhandleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action {
    
    self.action = action;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:controlEvent];
}


- (void)callActionBlock:(id)sender {
    if (self.action) {
        self.action(sender);
    }
}

- (void)setAction:(ActionBlock)action {
    objc_setAssociatedObject(self, &yyActionBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ActionBlock)action {
    return objc_getAssociatedObject(self, &yyActionBlockKey);
}


@end
