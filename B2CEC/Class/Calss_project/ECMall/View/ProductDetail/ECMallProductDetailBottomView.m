//
//  ECMallProductDetailBottomView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallProductDetailBottomView.h"
#import "ChatViewController.h"

@implementation ECMallProductDetailBottomView

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    
    CGFloat space = (SCREENWIDTH - SCREENWIDTH * (232.f / 750.f) * 2.f - 49.f * 3.f) / 4.f;
    
    if (!_buyBtn) {
        _buyBtn = [UIButton new];
    }
    [self addSubview:_buyBtn];
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyBtn setBackgroundColor:UIColorFromHexString(@"#EB3A41")];
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH * (232.f / 750.f));
    }];
    [_buyBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickBuyBtn) {
            weakSelf.clickBuyBtn();
        }
    }];
    
    if (!_addToCartBtn) {
        _addToCartBtn = [UIButton new];
    }
    [self addSubview:_addToCartBtn];
    [_addToCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_addToCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addToCartBtn setBackgroundColor:UIColorFromHexString(@"#333333")];
    [_addToCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf);
        make.right.mas_equalTo(weakSelf.buyBtn.mas_left);
        make.width.mas_equalTo(SCREENWIDTH * (232.f / 750.f));
    }];
    [_addToCartBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickAddToCartBtn) {
            weakSelf.clickAddToCartBtn();
        }
    }];
    
    if (!_cartView) {
        _cartView = [UIView new];
    }
    [self addSubview:_cartView];
    [_cartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.addToCartBtn.mas_left).offset(-space);
        make.size.mas_equalTo(CGSizeMake(49.f, 49.f));
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    if (!_cartBtn) {
        _cartBtn = [UIButton new];
    }
    [_cartView addSubview:_cartBtn];
    [_cartBtn setImage:[UIImage imageNamed:@"shop_shop"] forState:UIControlStateNormal];
    [_cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.cartView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_cartBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickCartBtn) {
            weakSelf.clickCartBtn();
        }
    }];
    
    if (!_countLabel) {
        _countLabel = [UILabel new];
        [_cartView addSubview:_countLabel];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.backgroundColor = MainColor;
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.cornerRadius = 10;
        _countLabel.hidden = YES;
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
            make.top.mas_equalTo(weakSelf.cartView.mas_top);
            make.right.mas_equalTo(weakSelf.cartView.mas_right).offset(-3.f);
        }];
    }
    //让_animationView指向购物车view /by Tristan
    _animationView = _cartView;
    
    if (!_serviceBtn) {
        _serviceBtn = [UIButton new];
    }
    [self addSubview:_serviceBtn];
    [_serviceBtn setImage:[UIImage imageNamed:@"shop_message"] forState:UIControlStateNormal];
    [_serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(space);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(49.f, 49.f));
    }];
    [_serviceBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
//        NSString *hotlineId = [CMPublicDataManager sharedCMPublicDataManager].publicDataModel.hotlineId;
//        ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:hotlineId
//                                                                        conversationType:EMConversationTypeChat];
//        [WEAKSELF_VC_BASENAVI pushViewController:vc animated:YES titleLabel:@"在线客服"];
        if (weakSelf.clicksServiceBtn) {
            weakSelf.clicksServiceBtn();
        }
    }];
    
    if (!_collectBtn) {
        _collectBtn = [UIButton new];
    }
    [self addSubview:_collectBtn];
    [_collectBtn setImage:[UIImage imageNamed:@"shop_like"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"shop_like_s"] forState:UIControlStateSelected];
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(weakSelf.serviceBtn.mas_right).offset(space);
        make.size.mas_equalTo(CGSizeMake(49.f, 49.f));
    }];
    [_collectBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickCollectBtn) {
            weakSelf.clickCollectBtn();
        }
    }];
    
}

#pragma mark - Setter

- (void)setCount:(NSInteger)count {
    _count = count;
    _countLabel.text = [NSString stringWithFormat:@"%ld", count];
    if (count > 0) {
        _countLabel.hidden = NO;
    } else {
        _countLabel.hidden = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
