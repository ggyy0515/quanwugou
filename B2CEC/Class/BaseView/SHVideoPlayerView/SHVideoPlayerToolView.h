//
//  SHVideoPlayerToolView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHVideoPlayerToolView : UIView
//播放进度
@property (assign,nonatomic) NSTimeInterval currentTimeInterval;
//加载进度
@property (assign,nonatomic) NSTimeInterval loadTimeInterval;
//总进度
@property (assign,nonatomic) NSTimeInterval allTimeInterval;
//是否全屏
@property (assign,nonatomic) BOOL isFull;
//滑动进度条
@property (copy,nonatomic) void (^updateCurrentTimeInterval)(NSTimeInterval currentTimeInterval);
//点击全屏
@property (copy,nonatomic) void (^fullScreenClick)(BOOL isFull);
@end
