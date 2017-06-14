//
//  NSString+TrStringTools.m
//  TrCommerce
//
//  Created by Tristan on 15/11/3.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "NSString+TrStringTools.h"


@implementation NSString (TrStringTools)

- (NSString *)urlEncodedUTF8String {
    
    return (id)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(0, (CFStringRef)self, 0,
                                                                         (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8));
    
}

- (CGFloat)computeTextHeightWith:(UIFont *)font withWidth:(CGFloat )width
{
    
    NSDictionary *titleAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil];
    
    return  ceilf(rect.size.height);
    
}

- (NSString *)replaceCharacter:(NSString *)formerStr withCharacter:(NSString *)nowStr{
    NSString *character = nil;
    NSMutableString *mutableStr = [NSMutableString stringWithString:self];
    for (int index = 0; index < mutableStr.length; index ++) {
        character = [mutableStr substringWithRange:NSMakeRange(index, 1)];
        if ([character isEqualToString:formerStr]) {
            [mutableStr replaceCharactersInRange:NSMakeRange(index, 1) withString:nowStr];
        }
    }
    return mutableStr;
    
}


+ (NSString *)getValueWithKey:(NSString *)key inDictonary:(NSDictionary *)dic{

     NSString *string = [[dic objectForKey:key] isKindOfClass:[NSNull class]] ? @"" : [dic objectForKey:key];
    return string;
}

@end
