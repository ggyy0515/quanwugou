//
//  UIActionSheet+ActionBlock.h
//  TrCommerce
//
//  Created by shuhua on 15/12/7.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (ActionBlock)

-(instancetype)initWithTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles
                 actionBlock:(void(^)(UIActionSheet *sender, NSInteger buttonIndex))block;

@end
