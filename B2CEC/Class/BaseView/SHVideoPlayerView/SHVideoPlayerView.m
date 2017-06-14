//
//  SHVideoPlayerView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "SHVideoPlayerView.h"
#import "UIDevice+Orientation.h"
#import "SHVideoPlayer.h"
#import "SHVideoPlayerToolView.h"
#import "SHVideoPlayerTitleView.h"
#import "SHVideoPlayerGestureView.h"

@interface SHVideoPlayerView()

@property (strong,nonatomic) SHVideoPlayer *videoPlayer;

@property (strong,nonatomic) SHVideoPlayerTitleView *titlView;

@property (strong,nonatomic) SHVideoPlayerToolView *toolView;

@property (strong,nonatomic) SHVideoPlayerGestureView *gestureView;

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@property (assign,nonatomic) CGRect customFrame;

@end

@implementation SHVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.customFrame = frame;
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    WEAK_SELF
    
    if (!_videoPlayer) {
        _videoPlayer = [SHVideoPlayer new];
    }
    _videoPlayer.userInteractionEnabled = YES;
    [_videoPlayer setLoadPlayTimeInterval:^(NSTimeInterval loadTime) {
        weakSelf.toolView.loadTimeInterval = loadTime;
    }];
    [_videoPlayer setAllPlayTimeInterval:^(NSTimeInterval allTime) {
        weakSelf.toolView.allTimeInterval = allTime;
    }];
    [_videoPlayer setCurrentPlayTimeInterval:^(NSTimeInterval currentTime) {
        weakSelf.toolView.currentTimeInterval = currentTime;
    }];
    [_videoPlayer setEndPlay:^{
        weakSelf.titlView.isPlayEnd = YES;
        [weakSelf.loadingView stopAnimating];
        [weakSelf.loadingView setHidesWhenStopped:YES];
    }];
    [_videoPlayer setStopPlay:^{
//        weakSelf.titlView
    }];
    [_videoPlayer setDirectionChange:^(BOOL isFull) {
        weakSelf.frame = isFull ? weakSelf.window.bounds : weakSelf.customFrame;
        weakSelf.toolView.isFull = isFull;
    }];
    [_videoPlayer setDelayPlay:^(BOOL isDelay) {
        if (isDelay) {
            [weakSelf.loadingView startAnimating];
        }else{
            [weakSelf.loadingView stopAnimating];
            [weakSelf.loadingView setHidesWhenStopped:YES];
        }
    }];
    
    if (!_titlView) {
        _titlView = [SHVideoPlayerTitleView new];
    }
    [_titlView setPlayOrPausePlayerBlock:^(BOOL isPlay) {
        if (isPlay) {
            [weakSelf.videoPlayer play];
            [weakSelf removeDelayUpdateUI];
            [weakSelf addDelayUpdateUI];
        }else{
            [weakSelf.videoPlayer pause];
            [weakSelf removeDelayUpdateUI];
            weakSelf.toolView.alpha = 1.f;
        }
        weakSelf.gestureView.alpha = 0.f;
    }];
    
    if (!_toolView) {
        _toolView = [SHVideoPlayerToolView new];
    }
    [_toolView setUpdateCurrentTimeInterval:^(NSTimeInterval currentTime) {
//        [weakSelf.videoPlayer seekToTimeWithSeconds:currentTime];
    }];
    [_toolView setFullScreenClick:^(BOOL isFull) {
        if (weakSelf.fullScreenClick) {
            weakSelf.fullScreenClick(isFull);
        }
    }];
    
    if (!_gestureView) {
        _gestureView = [SHVideoPlayerGestureView new];
    }
    _gestureView.userInteractionEnabled = YES;
    [_gestureView setUserTapGestureBlock:^() {
        weakSelf.gestureView.alpha = 0.f;
        [weakSelf addDelayUpdateUI];
        [UIView animateWithDuration:0.5f animations:^{
            weakSelf.toolView.alpha = 1.f;
            weakSelf.titlView.isShowStartBtn = YES;
        }];
    }];
    _gestureView.touchesBeganWithPointBlock = ^CGFloat(){
        return [weakSelf.videoPlayer getCurrentTimeInterval];
    };
    _gestureView.touchesEndWithPointBlock = ^(CGFloat rate){
        [weakSelf.videoPlayer seekToTimeWithSeconds:[weakSelf.videoPlayer getAllTimeInterval] * rate];
    };
    
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    
    [self addSubview:_videoPlayer];
    [self addSubview:_titlView];
    [self addSubview:_toolView];
    [self addSubview:_loadingView];
    [self addSubview:_gestureView];
}

#pragma mark  定时操作
- (void)addDelayUpdateUI{
    [self performSelector:@selector(delayUpdateUI) withObject:nil afterDelay:3.f];
}

- (void)removeDelayUpdateUI{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayUpdateUI) object:nil];
}

- (void)delayUpdateUI{
    self.titlView.isShowStartBtn = NO;
    [UIView animateWithDuration:3.f animations:^{
        self.toolView.alpha = 0.f;
    }];
    self.gestureView.alpha = 1.f;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _videoPlayer.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _titlView.frame = _videoPlayer.frame;
    _toolView.frame = CGRectMake(0.f, CGRectGetHeight(self.frame) - 44.f, CGRectGetWidth(self.frame), 44.f);
    _gestureView.frame = _videoPlayer.frame;
    _loadingView.center = _videoPlayer.center;
    /*
    [_videoPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_titlView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [_gestureView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf);
    }];
     */
}

#pragma mark  setter
- (void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl = videoUrl;
    
    self.toolView.alpha = 0.f;
    self.gestureView.alpha = 1.f;
    [self.loadingView startAnimating];
    [self.loadingView setHidesWhenStopped:YES];
    self.videoPlayer.videoUrl = videoUrl;
}

- (void)stopPlayer{
    [self.videoPlayer stop];
}
@end
