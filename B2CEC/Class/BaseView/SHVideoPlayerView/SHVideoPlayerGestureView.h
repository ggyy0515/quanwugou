//
//  SHVideoPlayerGestureView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHVideoPlayerGestureView : UIView

/**
 *  单击时/双击时,判断tap的numberOfTapsRequired
 */
@property (nonatomic, copy)void (^userTapGestureBlock)();
/**
 * 开始触摸
 */
@property (nonatomic, copy) CGFloat (^touchesBeganWithPointBlock)();
/**
 * 结束触摸
 */
@property (nonatomic, copy) void (^touchesEndWithPointBlock)(CGFloat rate);

@end
