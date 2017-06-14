//
//  SHVideoPlayer.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHVideoPlayer : UIView
//视频链接
@property (strong,nonatomic) NSString *videoUrl;

//获取加载进度
@property (copy,nonatomic) void (^loadPlayTimeInterval)(NSTimeInterval loadTime);
//获取当前进度
@property (copy,nonatomic) void (^currentPlayTimeInterval)(NSTimeInterval currentTime);
//获取总进度
@property (copy,nonatomic) void (^allPlayTimeInterval)(NSTimeInterval allTime);
//播放结束
@property (copy,nonatomic) void (^endPlay)();
//播放关闭
@property (copy,nonatomic) void (^stopPlay)();
//播放是否延迟
@property (nonatomic, copy)void (^delayPlay)(BOOL isDelay);
//方向改变
@property (copy,nonatomic) void (^DirectionChange)(BOOL isFull);

//播放
- (void)play;
//暂停
- (void)pause;
//关闭
- (void)stop;
//定位到播放时间
- (void)seekToTimeWithSeconds:(NSTimeInterval)time;
//取得当前播放进度
- (NSTimeInterval)getCurrentTimeInterval;
//取得总时长
- (NSTimeInterval)getAllTimeInterval;
@end
