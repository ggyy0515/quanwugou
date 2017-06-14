//
//  UIImage+Redraw.h
//  TrCommerce
//
//  Created by shuhua on 15/11/25.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Redraw)

-(UIImage *)redrawImageWithSize:(CGSize)size;

- (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)tsimageWithColor:(UIColor *)color;

@end
