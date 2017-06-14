//
//  UIView+ViewController.m
//  TrCommerce
//
//  Created by Tristan on 15/11/5.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

/**
 *  @brief  找到当前view所在的viewcontroler
 */
- (UIViewController *)viewController
{
    
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}


@end
