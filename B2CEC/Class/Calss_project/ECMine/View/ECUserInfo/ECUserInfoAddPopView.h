//
//  ECUserInfoAddPopView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECUserInfoAddPopView : UIView

- (void)show;

@property (copy,nonatomic) void (^clickBlock)(NSInteger index);

@end
