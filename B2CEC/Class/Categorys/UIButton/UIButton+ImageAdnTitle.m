//
//  UIButton+ImageAdnTitle.m
//  TrCommerce
//
//  Created by Tristan on 15/12/4.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "UIButton+ImageAdnTitle.h"

@implementation UIButton (ImageAdnTitle)

- (void)setImage:(UIImage *)image
       withTitle:(NSString *)title
            font:(UIFont *)font
        forState:(UIControlState)stateType {
    
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:font];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(35,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    self.titleLabel.font = font;
    [self setTitle:title forState:stateType];
}

@end
