//
//  ECMallProductDetailBottomView.h
//  B2CEC
//
//  Created by Tristan on 2016/11/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECMallProductDetailBottomView : UIView

@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIButton *addToCartBtn;
@property (nonatomic, strong) UIView *cartView;
@property (nonatomic, strong) UIButton *cartBtn;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *serviceBtn;

@property (nonatomic, assign) NSInteger count;

/**
 *  发生抖动动画的btn 指向购物车view by Tristan
 */
@property (nonatomic, strong) UIView *animationView;

/**
 点击收藏商品按钮
 */
@property (nonatomic, copy) void(^clickCollectBtn)();

/**
 点击加入购物车
 */
@property (nonatomic, copy) void(^clickAddToCartBtn)();
/**
 点击购物车
 */
@property (nonatomic, copy) void(^clickCartBtn)();
/**
 点击立即购买
 */
@property (nonatomic, copy) void(^clickBuyBtn)();
/**
 点击联系客服
 */
@property (nonatomic, copy) void(^clicksServiceBtn)();

@end
