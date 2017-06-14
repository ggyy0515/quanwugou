//
//  ECHomeOptionsView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ECHomeOptionsView : UIView
/**
 选项数组
 */
@property (strong,nonatomic) NSMutableArray *newsTypeArray;

@property (assign,nonatomic) NSInteger currentIndex;
/**
 点击选项卡
 */
@property (copy,nonatomic) void (^didSelectIndex)(NSInteger);
/**
 
 */
@property (copy,nonatomic) void (^closeClick)(NSMutableArray *array);

@end
