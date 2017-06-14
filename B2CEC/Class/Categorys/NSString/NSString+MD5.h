//
//  NSString+MD5.h
//  UCwashCar
//
//  Created by cys on 15/2/2.
//  Copyright (c) 2015年 cys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

+(NSString *)getMd5_32Bit_String:(NSString *)srcString;

@end
