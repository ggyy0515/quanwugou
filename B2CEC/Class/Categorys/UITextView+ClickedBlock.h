//
//  UITextView+ClickedBlock.h
//  ZhongShanEC
//
//  Created by 曙华国际 on 16/6/2.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (ClickedBlock)

- (instancetype)initWithFrame:(CGRect)frame
              textChangeBlock:(void(^)(UITextView * textView))textChangeBlock;

@end
