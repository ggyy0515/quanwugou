//
//  UIActionSheet+ActionBlock.m
//  TrCommerce
//
//  Created by shuhua on 15/12/7.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "UIActionSheet+ActionBlock.h"
#import <objc/runtime.h>

static NSString *kActionSheetBlockIdentify = @"kActionSheetBlockIdentify";

@interface UIActionSheet ()<UIActionSheetDelegate>

@property (nonatomic,copy) void (^ActionBlock)(UIActionSheet *, NSInteger);

@end

@implementation UIActionSheet (ActionBlock)

-(instancetype)initWithTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles
                 actionBlock:(void (^)(UIActionSheet *, NSInteger))block
{
    if ((self = [self initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil])) {
        self.ActionBlock = block;
    }
    return self;
}

-(void)setActionBlock:(void (^)(UIActionSheet *, NSInteger))ActionBlock
{
    objc_setAssociatedObject(self, (__bridge const void *)(kActionSheetBlockIdentify), ActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(UIActionSheet *,NSInteger))ActionBlock
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kActionSheetBlockIdentify));
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.ActionBlock) {
        self.ActionBlock(actionSheet,buttonIndex);
    }
}

@end
