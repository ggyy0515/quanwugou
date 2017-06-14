//
//  ECProductDetailProductView.h
//  B2CEC
//
//  Created by Tristan on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECCartFactoryModel;

@interface ECProductDetailProductView : UIView

- (instancetype)initWithProtable:(NSString *)protable proId:(NSString *)proId;

/**
 读取到商品图片后的回调
 */
@property (nonatomic, copy) void(^didLoadProductAnimationPic)(NSURL *url);
/**
 获取到库存后的回调
 */
@property(nonatomic, copy) void(^didGetStock)(NSString * stock);
/**
 读取到商品系列后的回调
 */
@property (nonatomic, copy) void(^didLoadProductSerise)(NSString *serise);

/**
 查看更多评论
 */
@property (nonatomic, copy) void(^moreAppraiseAction)();

/**
 查看商品图文详情
 */
@property (nonatomic, copy) void(^checkWebDetailAction)();

/**
 点击更多的回调
 */
@property (nonatomic, copy) void(^moreBtnClick)();

/**
 获取到收藏状态回调
 */
@property (nonatomic, copy) void(^updateCollectionState)(BOOL isCollect);
/**
 获取到是否是抢购的回调
 */
@property (nonatomic, copy) void(^didGetPanicBuyState)(BOOL isPanicBuy);
/**
 获取到是否是尾货
 */
@property (nonatomic, copy) void(^didGetLeftProductState)(BOOL isLeftProduct);
/**
 获取到立即购买需要的数据模型
 */
@property (nonatomic, copy) void(^didGetCartModel)(ECCartFactoryModel *model);
/**
 获取数据之后告诉上层商品名
 */
@property (nonatomic, copy) void(^getProductTitleBlock)(NSString *title);
/**
 获取到商品对应的工厂用户id（环信id）
 */
@property (nonatomic, copy) void(^didGetFactoryUserId)(NSString *factoryUserId);

@end
