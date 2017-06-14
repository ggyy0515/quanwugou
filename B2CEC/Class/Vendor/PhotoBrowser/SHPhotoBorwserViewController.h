//
//  SHPhotoBorwserViewController.h
//  ZhongShanEC
//
//  Created by 曙华国际 on 16/6/6.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@interface SHPhotoBorwserViewController : CMBaseViewController

@property (nonatomic, strong) NSArray *imageArray;//图片数组

@property (nonatomic, assign) NSInteger currentIndex; //选中的图片下标

@property (nonatomic, strong) NSArray *urlKeyArray;//URL  key值数组

@property (nonatomic, assign) BOOL isEdit;//是否可删除

@property (nonatomic, copy) void (^btnDoneBlock)(NSArray *removeIndexArray,NSInteger currentIndex); //操作之后的需要被删除的下标数组,以及删除成功之后应当显示的图片下标

- (void)updateBorwser;

@end
