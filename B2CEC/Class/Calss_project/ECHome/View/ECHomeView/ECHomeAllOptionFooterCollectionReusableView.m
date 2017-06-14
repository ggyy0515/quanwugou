//
//  ECHomeAllOptionFooterCollectionReusableView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/16.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeAllOptionFooterCollectionReusableView.h"

@interface ECHomeAllOptionFooterCollectionReusableView()

@property (strong,nonatomic) UILabel *tipsLab;

@property (strong,nonatomic) UIView *lineView;

@end

@implementation ECHomeAllOptionFooterCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    WEAK_SELF
    
    if (!_tipsLab) {
        _tipsLab = [UILabel new];
    }
    _tipsLab.text = @"暂无分类";
    _tipsLab.font = FONT_28;
    _tipsLab.textColor = LightMoreColor;
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self addSubview:_tipsLab];
    [self addSubview:_lineView];
    
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)setIsShowLine:(BOOL)isShowLine{
    isShowLine = isShowLine;
    _lineView.hidden = !isShowLine;
}

- (void)setIsHaveData:(BOOL)isHaveData{
    _isHaveData = isHaveData;
    _tipsLab.hidden = isHaveData;
}

@end
