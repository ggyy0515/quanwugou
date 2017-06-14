//
//  ECMoreProductDetailViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/11/24.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@class ECMallProductModel;

@interface ECMoreProductDetailViewController : CMBaseViewController

/**
 收藏按钮点击回调
 */
@property (nonatomic, copy) void(^collectBtnClick)();
/**
 查看详情按钮点击回调
 */
@property (nonatomic, copy) void(^toDetailBtnClick)();

/**
 构造方法

 @param model 商品列表数据模型
 @return 实例对象
 */
- (instancetype)initWithProductModel:(ECMallProductModel *)model;

@end
