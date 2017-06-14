//
//  SHVideoPlayer.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "SHVideoPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SHVideoPlayer()

@property (strong,nonatomic) AVPlayer *player;

@property (strong,nonatomic) AVPlayerItem *playerItem;

@property (nonatomic, strong) AVURLAsset *videoURLAsset;
//界面更新时间ID
@property (nonatomic, strong) id playTimeObserver;
//以屏幕刷新率进行定时操作
@property (nonatomic, strong) CADisplayLink *link;

@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation SHVideoPlayer

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)p {
    [(AVPlayerLayer *)[self layer] setPlayer:p];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    self.backgroundColor = [UIColor blackColor];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];//注册监听，屏幕方向改变
}

- (void)playerInit{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    if (self.player) {
        self.player = nil;
        [self removeObserver];
    }
    self.videoURLAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.videoUrl] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
    if (self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }else {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    [self setPlayer:self.player];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性变化
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//监听loadedTimeRanges属性变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xjPlayerEndPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];//注册监听，视屏播放完成
}

#pragma mark - **************************** 监听事件 *************************************
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            CMTime duration = self.playerItem.duration;//获取视屏总长
            CGFloat totalSecond = CMTimeGetSeconds(duration);//转换成秒
            if (self.allPlayTimeInterval) {
                self.allPlayTimeInterval(totalSecond);
            }
            
            [self addPeriodicTimeObserverForInterval];//监听播放状态
            
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSTimeInterval timeInterval = [self loadPlayerAvailableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        if (self.loadPlayTimeInterval) {
            self.loadPlayTimeInterval(timeInterval/totalDuration);
        }
    }
    
}

//视屏播放完后的通知事件。从头开始播放；
- (void)xjPlayerEndPlay:(NSNotification*)notification{
    WEAK_SELF
    [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf pause];
        if (weakSelf.endPlay) {
            weakSelf.endPlay();
        }
    }];
}

- (void)addPeriodicTimeObserverForInterval{
    WEAK_SELF
    
    self.playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = weakSelf.playerItem.currentTime.value/weakSelf.playerItem.currentTime.timescale;//获取当前时间
        if (weakSelf.currentPlayTimeInterval) {
            weakSelf.currentPlayTimeInterval(currentSecond);
        }
    }];
}

- (void)removeObserver{
    if (self.link) {
        [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.link = nil;
    }
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [self.player removeTimeObserver:self.playTimeObserver];
    self.playTimeObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];//注册监听，屏幕方向改变
}

#pragma mark - 屏幕方向改变的监听
//屏幕方向改变时的监听
- (void)orientChange:(NSNotification *)notification{
    UIDeviceOrientation orient = [[UIDevice currentDevice] orientation];
    if (self.DirectionChange) {
        self.DirectionChange(orient);
    }
}

//刷新，看播放是否卡顿
- (void)upadte{
    NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
    if (self.delayPlay) {
        self.delayPlay(current == self.lastTime);
    }
    self.lastTime = current;
}
#pragma mark   方法实现
- (void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl = videoUrl;
    
    [self playerInit];
    [self play];
}

- (void)play{
    [self.player play];
    if (!self.link) {
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(upadte)];//和屏幕频率刷新相同的定时器
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)pause{
    if (self.link) {
        [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.link = nil;
    }
    [self.player pause];
}

- (void)stop{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self removeObserver];
    [self.player pause];
    [self.player setRate:0];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.playerItem = nil;
    self.player = nil;
    if (self.stopPlay) {
        self.stopPlay();
    }
}

- (void)seekToTimeWithSeconds:(NSTimeInterval)time{
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (NSTimeInterval)getCurrentTimeInterval{
    CMTime ctime =  [self.player currentTime];
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        return ctime.value / ctime.timescale / CMTimeGetSeconds(self.player.currentItem.duration);
    }else{
        return 0;
    }
}

- (NSTimeInterval)getAllTimeInterval{
    return CMTimeGetSeconds(self.player.currentItem.duration);
}
#pragma mark  
//计算缓冲区
- (NSTimeInterval)loadPlayerAvailableDuration{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];//获取缓冲区域
    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds+durationSeconds;//计算缓冲进度
    return result;
}

@end
