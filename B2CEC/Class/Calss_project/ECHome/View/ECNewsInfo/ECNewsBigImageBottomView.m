//
//  ECCommentInputView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsBigImageBottomView.h"

@interface ECNewsBigImageBottomView()

@property (strong,nonatomic) UILabel *inputLab;

@property (strong,nonatomic) UIButton *inputBtn;

@property (strong,nonatomic) UIButton *commentBtn;

@property (strong,nonatomic) UILabel *commentLab;

@property (strong,nonatomic) UIButton *collecBtn;

@property (strong,nonatomic) UIButton *shareBtn;

@end

@implementation ECNewsBigImageBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    WEAK_SELF
    
    if (!_inputLab) {
        _inputLab = [UILabel new];
    }
    _inputLab.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.1];
    _inputLab.layer.cornerRadius = 18.f;
    _inputLab.layer.masksToBounds = YES;
    _inputLab.text = @"    写评论...";
    _inputLab.textColor = LightColor;
    _inputLab.font = FONT_28;
    
    if (!_inputBtn) {
        _inputBtn = [UIButton new];
    }
    [_inputBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.inputClickBlock) {
            weakSelf.inputClickBlock();
        }
    }];
    
    if (!_commentBtn) {
        _commentBtn = [UIButton new];
    }
    [_commentBtn setImage:[UIImage imageNamed:@"icon_comment_w"] forState:UIControlStateNormal];
    [_commentBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.commentClickBlock) {
            weakSelf.commentClickBlock();
        }
    }];
    
    if (!_commentLab) {
        _commentLab = [UILabel new];
    }
    _commentLab.textColor = [UIColor whiteColor];
    _commentLab.backgroundColor = CompColor;
    _commentLab.font = [UIFont systemFontOfSize:10.f];
    _commentLab.textAlignment = NSTextAlignmentCenter;
    _commentLab.layer.cornerRadius = 7.f;
    _commentLab.layer.masksToBounds = YES;
    
    if (!_collecBtn) {
        _collecBtn = [UIButton new];
    }
    [_collecBtn setImage:[UIImage imageNamed:@"follow_w"] forState:UIControlStateNormal];
    [_collecBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.collecClickBlock) {
            weakSelf.collecClickBlock();
        }
    }];
    
    if (!_shareBtn) {
        _shareBtn = [UIButton new];
    }
    [_shareBtn setImage:[UIImage imageNamed:@"share_w"] forState:UIControlStateNormal];
    [_shareBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.shareClickBlock) {
            weakSelf.shareClickBlock();
        }
    }];
    
    [self addSubview:_inputLab];
    [self addSubview:_inputBtn];
    [self addSubview:_commentBtn];
    [self addSubview:_commentLab];
    [self addSubview:_collecBtn];
    [self addSubview:_shareBtn];
    
    [_inputLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(36.f);
        make.right.mas_equalTo(weakSelf.commentBtn.mas_left).offset(-20.f);
    }];
    
    [_inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.inputLab);
    }];
    
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24.f, 24.f));
        make.centerY.mas_equalTo(weakSelf.inputLab.mas_centerY);
        make.right.mas_equalTo(weakSelf.collecBtn.mas_left).offset(-20.f);
    }];
    
    [_commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 14.f));
        make.centerX.mas_equalTo(weakSelf.commentBtn.mas_right).offset(-3.f);
        make.centerY.mas_equalTo(weakSelf.commentBtn.mas_top).offset(3.f);
    }];

    [_collecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(weakSelf.commentBtn);
        make.right.mas_equalTo(weakSelf.shareBtn.mas_left).offset(-20.f);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(weakSelf.commentBtn);
        make.right.mas_equalTo(-20.f);
    }];
}

- (void)setCommentCount:(NSString *)commentCount{
    _commentCount = commentCount;
    
    if (commentCount.integerValue == 0) {
        _commentLab.hidden = YES;
        return;
    }
    _commentLab.text = commentCount.integerValue > 99 ? @"99+" : commentCount;
}

@end
