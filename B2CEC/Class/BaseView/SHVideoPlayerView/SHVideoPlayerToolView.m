//
//  SHVideoPlayerToolView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "SHVideoPlayerToolView.h"

@interface SHVideoPlayerToolView()

@property (strong,nonatomic) UILabel *currentTimeLab;

@property (strong,nonatomic) UISlider *timeSlider;

@property (strong,nonatomic) UISlider *loadSlider;

@property (strong,nonatomic) UILabel *allTimeLab;

@property (strong,nonatomic) UIButton *fullBtn;

@end

@implementation SHVideoPlayerToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.7];
    if (!_currentTimeLab) {
        _currentTimeLab = [UILabel new];
    }
    _currentTimeLab.font = [UIFont systemFontOfSize:12.f];
    _currentTimeLab.textAlignment = NSTextAlignmentCenter;
    _currentTimeLab.textColor = [UIColor whiteColor];
    _currentTimeLab.text = @"00:00";
    
    if (!_loadSlider) {
        _loadSlider = [UISlider new];
    }
    _loadSlider.minimumValue = 0.f;
    _loadSlider.userInteractionEnabled = NO;
    [_loadSlider setThumbImage:[UIImage imageNamed:@"video_time_loadSlider"] forState:UIControlStateNormal];
    [_loadSlider setMaximumTrackImage:[UIImage imageNamed:@"video_time_noload"] forState:UIControlStateNormal];
    [_loadSlider setMinimumTrackImage:[UIImage imageNamed:@"video_time_load"] forState:UIControlStateNormal];
    
    if (!_timeSlider) {
        _timeSlider = [UISlider new];
    }
    _timeSlider.minimumValue = 0.f;
    [_timeSlider setThumbImage:[UIImage imageNamed:@"video_time_slider"] forState:UIControlStateNormal];
    [_timeSlider setMaximumTrackImage:[UIImage imageNamed:@"video_time_clear"] forState:UIControlStateNormal];
    [_timeSlider setMinimumTrackImage:[UIImage imageNamed:@"video_time_current"] forState:UIControlStateNormal];
    [_timeSlider addTarget:self action:@selector(timeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_timeSlider addTarget:self action:@selector(timeSliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    
    if (!_allTimeLab) {
        _allTimeLab = [UILabel new];
    }
    _allTimeLab.font = [UIFont systemFontOfSize:12.f];
    _allTimeLab.textAlignment = NSTextAlignmentCenter;
    _allTimeLab.textColor = [UIColor whiteColor];
    _allTimeLab.text = @"00:00";
    
    if (!_fullBtn) {
        _fullBtn = [UIButton new];
    }
    [_fullBtn setImage:[UIImage imageNamed:@"video_fullscreen"] forState:UIControlStateNormal];
    [_fullBtn setImage:[UIImage imageNamed:@"video_miniscreen"] forState:UIControlStateSelected];
    [_fullBtn addTarget:self action:@selector(fullScreenDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_currentTimeLab];
    [self addSubview:_loadSlider];
    [self addSubview:_timeSlider];
    [self addSubview:_allTimeLab];
    [self addSubview:_fullBtn];
}

- (void)timeSliderValueChanged:(UISlider *)sender{
    if (sender.value == 0.f) {
        if (self.updateCurrentTimeInterval) {
            self.updateCurrentTimeInterval(sender.value);
        }
    }
}

- (void)timeSliderTouchUpInSide:(UISlider *)sender{
    if (self.updateCurrentTimeInterval) {
        self.updateCurrentTimeInterval(sender.value * self.allTimeInterval);
    }
}

- (void)fullScreenDidClick:(UIButton *)sender{
    self.fullBtn.selected = !self.fullBtn.selected;
    if (self.fullScreenClick) {
        self.fullScreenClick(self.fullBtn.selected);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    WEAK_SELF
    
    [_currentTimeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0.f);
        make.width.mas_equalTo(58.f);
    }];
    
    [_loadSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.timeSlider);
    }];
    
    [_timeSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.currentTimeLab.mas_right);
        make.right.mas_equalTo(weakSelf.allTimeLab.mas_left);
    }];
    
    [_allTimeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(weakSelf.currentTimeLab);
        make.right.mas_equalTo(weakSelf.fullBtn.mas_left);
    }];
    
    [_fullBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
        make.right.mas_equalTo(-16.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
}

- (void)setCurrentTimeInterval:(NSTimeInterval)currentTimeInterval{
    _currentTimeInterval = currentTimeInterval;
    _currentTimeLab.text = [CMPublicMethod playerTimeStyle:currentTimeInterval];
    _timeSlider.value = currentTimeInterval;
}

- (void)setLoadTimeInterval:(NSTimeInterval)loadTimeInterval{
    _loadTimeInterval = loadTimeInterval;
    _loadSlider.value = loadTimeInterval;
}

- (void)setAllTimeInterval:(NSTimeInterval)allTimeInterval{
    _allTimeInterval = allTimeInterval;
    _allTimeLab.text = [CMPublicMethod playerTimeStyle:allTimeInterval];
    _loadSlider.maximumValue = allTimeInterval;
    _timeSlider.maximumValue = allTimeInterval;
}

@end
