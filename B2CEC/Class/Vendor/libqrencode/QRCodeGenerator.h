//
//  QRCodeGenerator.h
//  MiMi
//
//  Created by shuhua on 15/5/20.
//  Copyright (c) 2015年 shuhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeGenerator : NSObject

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;
+ (UIImage *) twoDimensionCodeImage:(UIImage *)twoDimensionCode withAvatarImage:(UIImage *)avatarImage;

@end
