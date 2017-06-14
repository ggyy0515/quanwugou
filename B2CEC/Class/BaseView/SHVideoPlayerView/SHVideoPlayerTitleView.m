//
//  SHVideoPlayerTitleView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "SHVideoPlayerTitleView.h"

@interface SHVideoPlayerTitleView()

@property (strong,nonatomic) UIButton *startOrPauseBtn;

@end

@implementation SHVideoPlayerTitleView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    
    if (!_startOrPauseBtn) {
        _startOrPauseBtn = [UIButton new];
    }
    _startOrPauseBtn.alpha = 0.f;
    _startOrPauseBtn.selected = YES;
    [_startOrPauseBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
    [_startOrPauseBtn setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateSelected];
    [_startOrPauseBtn addTarget:self action:@selector(playOrPauseClick:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_startOrPauseBtn];
}

- (void)playOrPauseClick:(UIButton *)sender{
    self.startOrPauseBtn.selected = !self.startOrPauseBtn.selected;
    if (self.playOrPausePlayerBlock) {
        self.playOrPausePlayerBlock(self.startOrPauseBtn.selected);
    }
}

- (void)setIsPlayEnd:(BOOL)isPlayEnd{
    _isPlayEnd = isPlayEnd;
    _startOrPauseBtn.selected = NO;
    _startOrPauseBtn.alpha = 1.f;
}

- (void)setIsShowStartBtn:(BOOL)isShowStartBtn{
    _isShowStartBtn = isShowStartBtn;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.startOrPauseBtn.alpha = isShowStartBtn ? 1.f : 0.f;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    WEAK_SELF
    
    [_startOrPauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
        make.center.equalTo(weakSelf);
    }];
}
@end
