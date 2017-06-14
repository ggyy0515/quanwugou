//
//  CMImageBrowser.h
//  B2CEC
//
//  Created by Tristan on 2017/1/6.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMImageBrowser : UIView

+ (void)showBrowserInView:(UIView *)superView
          backgroundColor:(UIColor *)backgroundColor
                imageUrls:(NSArray <NSString *> *)imageUrls
                fromIndex:(NSInteger)fromIndex;

@end
