//
//  ECPointConfirmOrderBottomView.m
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointConfirmOrderBottomView.h"

@interface ECPointConfirmOrderBottomView ()

@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIView *line;

@end


@implementation ECPointConfirmOrderBottomView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self addSubview:_line];
    _line.backgroundColor = UIColorFromHexString(@"#DDDDDD");
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf);
        make.height.mas_equalTo(0.5f);
    }];
    
    if (!_payBtn) {
        _payBtn = [UIButton new];
    }
    [self addSubview:_payBtn];
    [_payBtn setBackgroundColor:UIColorFromHexString(@"#1A191E")];
    [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [_payBtn setTitleColor:UIColorFromHexString(@"#ffffff") forState:UIControlStateNormal];
    _payBtn.titleLabel.font = FONT_32;
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH * (300.f / 750.f));
    }];
    [_payBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickPayBtn) {
            weakSelf.clickPayBtn();
        }
    }];
    
    if (!_pointLabel) {
        _pointLabel = [UILabel new];
    }
    [self addSubview:_pointLabel];
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(12.f);
        make.bottom.mas_equalTo(weakSelf);
        make.right.mas_equalTo(weakSelf.payBtn.mas_left);
        make.top.mas_equalTo(weakSelf.line.mas_bottom);
    }];
    
}

- (void)setPoint:(CGFloat)point {
    _point = point;
    NSMutableAttributedString *pointStr = [[NSMutableAttributedString alloc] initWithString:@"应付积分："
                                                                                 attributes:@{NSFontAttributeName:FONT_28,
                                                                                              NSForegroundColorAttributeName:DarkMoreColor}];
    [pointStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0lf", point]
                                                                     attributes:@{NSFontAttributeName:FONT_B_36,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#ee383b")}]];
    _pointLabel.attributedText = pointStr;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end