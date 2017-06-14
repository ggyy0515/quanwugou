//
//  ECUserInfoAddPopView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoAddPopView.h"


@interface ECUserInfoAddPopView()

@property (strong,nonatomic) UIView *bgTapView;

@property (strong,nonatomic) UIView *bgView;

@property (strong,nonatomic) UIImageView *workImageView;

@property (strong,nonatomic) UILabel *workLab;

@property (strong,nonatomic) UIButton *workBtn;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIImageView *logImageView;

@property (strong,nonatomic) UILabel *logLab;

@property (strong,nonatomic) UIButton *logBtn;

@end

@implementation ECUserInfoAddPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)createUI{
    WEAK_SELF
    if (!_bgTapView) {
        _bgTapView = [UIView new];
    }
    _bgTapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    [_bgTapView addGestureRecognizer:tap];
    
    if (!_bgView) {
        _bgView = [UIView new];
    }
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 5.f;
    _bgView.layer.masksToBounds = YES;
    
    if (!_workImageView) {
        _workImageView = [UIImageView new];
    }
    _workImageView.image = [UIImage imageNamed:@"zuopin"];
    
    if (!_workLab) {
        _workLab = [UILabel new];
    }
    _workLab.text = @"发表案例";
    _workLab.textColor = DarkMoreColor;
    _workLab.font = FONT_32;
    
    if (!_workBtn) {
        _workBtn = [UIButton new];
    }
    [_workBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickBlock) {
            weakSelf.clickBlock(0);
        }
        [weakSelf hidden];
    }];
    
    if (!_logImageView) {
        _logImageView = [UIImageView new];
    }
    _logImageView.image = [UIImage imageNamed:@"rizhi"];
    
    if (!_logLab) {
        _logLab = [UILabel new];
    }
    _logLab.text = @"发表日志";
    _logLab.textColor = DarkMoreColor;
    _logLab.font = FONT_32;
    
    if (!_logBtn) {
        _logBtn = [UIButton new];
    }
    [_logBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickBlock) {
            weakSelf.clickBlock(1);
        }
        [weakSelf hidden];
    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.superview addSubview:_bgTapView];
    [self.superview addSubview:_bgView];
    [_bgView addSubview:_workImageView];
    [_bgView addSubview:_workLab];
    [_bgView addSubview:_workBtn];
    [_bgView addSubview:_logImageView];
    [_bgView addSubview:_logLab];
    [_bgView addSubview:_logBtn];
    [_bgView addSubview:_lineView];
    
    [_bgTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(142.f, 98.f));
        make.top.mas_equalTo(64.f);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_workImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
        make.left.mas_equalTo(20.f);
        make.centerY.mas_equalTo(weakSelf.workBtn.mas_centerY);
    }];
    
    [_workLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.workImageView.mas_right).offset(20.f);
        make.right.mas_equalTo(0.f);
        make.centerY.mas_equalTo(weakSelf.workBtn.mas_centerY);
    }];
    
    [_workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(49.f);
    }];
    
    [_logImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.left.equalTo(weakSelf.workImageView);
        make.centerY.mas_equalTo(weakSelf.logBtn.mas_centerY);
    }];
    
    [_logLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.workLab);
        make.centerY.mas_equalTo(weakSelf.logBtn.mas_centerY);
    }];
    
    [_logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(49.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.centerY.mas_equalTo(weakSelf.bgView.mas_centerY);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)show{
    [self createUI];
}

- (void)hidden{
    [self.bgView removeFromSuperview];
    [self.bgTapView removeFromSuperview];
}

@end
