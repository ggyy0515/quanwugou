//
//  ECPointProductDetailBottomView.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointProductDetailBottomView.h"

@interface ECPointProductDetailBottomView ()

@property (nonatomic, strong) UIButton *buyBtn;

@end

@implementation ECPointProductDetailBottomView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_buyBtn) {
        _buyBtn = [UIButton new];
    }
    [self addSubview:_buyBtn];
    [_buyBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:UIColorFromHexString(@"#ffffff") forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = FONT_32;
    _buyBtn.backgroundColor = MainColor;
    _buyBtn.layer.cornerRadius = 20.f;
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(-40.f);
        make.height.mas_equalTo(40.f);
    }];
    [_buyBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickBuyBtn) {
            weakSelf.clickBuyBtn();
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
