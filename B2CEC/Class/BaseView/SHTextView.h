//
//  SHTextView.h
//  ZhongShanEC
//
//  Created by 曙华国际 on 16/6/2.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHTextView : UITextView
/*!
 *  提示文字
 */
@property (copy,nonatomic) NSString *placeholder;
/*!
 *  提示文字颜色
 */
@property (strong,nonatomic) UIColor *placeholderColor;
@end
