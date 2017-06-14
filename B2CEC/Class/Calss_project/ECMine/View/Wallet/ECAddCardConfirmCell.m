//
//  ECAddCardConfirmCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAddCardConfirmCell.h"

@interface ECAddCardConfirmCell ()

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation ECAddCardConfirmCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
    }
    [self.contentView addSubview:_confirmBtn];
    [_confirmBtn setTitle:@"确认添加" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor whiteColor];
    _confirmBtn.layer.cornerRadius = 4.f;
    _confirmBtn.titleLabel.font = FONT_32;
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_confirmBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickConfirmBtn) {
            weakSelf.clickConfirmBtn();
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
