//
//  UIButton+ImageAdnTitle.h
//  TrCommerce
//
//  Created by Tristan on 15/12/4.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ImageAdnTitle)

- (void)setImage:(UIImage *)image
       withTitle:(NSString *)title
            font:(UIFont *)font
        forState:(UIControlState)stateType;

@end
