//
//  CMSearchBar.h
//  TrCommerce
//
//  Created by Tristan on 15/11/6.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSearchBar : UISearchBar

/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancel”）
 *
 *  @param title 自定义文字
 */
- (void)setCancelButtonTitle:(NSString *)title;

@end
