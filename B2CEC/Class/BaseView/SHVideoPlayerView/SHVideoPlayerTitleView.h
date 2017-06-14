//
//  SHVideoPlayerTitleView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHVideoPlayerTitleView : UIView
//是否播放完毕
@property (assign,nonatomic) BOOL isPlayEnd;
//是否显示开始暂停按钮
@property (assign,nonatomic) BOOL isShowStartBtn;
//点击播放/暂停
@property (copy,nonatomic) void (^playOrPausePlayerBlock)(BOOL isPlay);

@end
