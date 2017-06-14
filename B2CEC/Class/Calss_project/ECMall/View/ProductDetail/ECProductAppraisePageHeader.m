//
//  ECProductAppraisePageHeader.m
//  B2CEC
//
//  Created by Tristan on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAppraisePageHeader.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface ECProductAppraisePageHeader ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HCSStarRatingView *ratingView;

@end

@implementation ECProductAppraisePageHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self addSubview:_titleLabel];
    _titleLabel.font = FONT_32;
    _titleLabel.textColor = DarkMoreColor;
    _titleLabel.text = @"商品满意度";
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf.mas_left).offset(8.f);
        make.width.mas_equalTo(100.f);
    }];
    
    if (!_ratingView) {
        _ratingView = [HCSStarRatingView new];
    }
    [self addSubview:_ratingView];
    _ratingView.minimumValue = 0;
    _ratingView.maximumValue = 5;
    _ratingView.value = 0;
    _ratingView.accurateHalfStars = YES;
    _ratingView.allowsHalfStars = YES;
    _ratingView.userInteractionEnabled = NO;
    _ratingView.filledStarImage = [UIImage imageNamed:@"rate_star_on"];
    _ratingView.emptyStarImage = [UIImage imageNamed:@"rate_star_off"];
    [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(170.f / 2.f, 30.f));
        make.right.mas_equalTo(weakSelf.mas_right).offset(-8.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
}

- (void)setScore:(CGFloat)score {
    _score = score;
    _ratingView.value = score;
}

@end
