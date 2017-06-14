//
//  ECHomeAllOptionHeaderCollectionReusableView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/16.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeAllOptionHeaderCollectionReusableView.h"

@interface ECHomeAllOptionHeaderCollectionReusableView()

@property (strong,nonatomic) UILabel *titleLab;

@end

@implementation ECHomeAllOptionHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    WEAK_SELF
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.font = FONT_32;
    _titleLab.textColor = DarkColor;
    
    [self addSubview:_titleLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.left.mas_equalTo(0.f);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    _titleLab.text = title;
}

@end
