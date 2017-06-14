//
//  ECMallFilterView.h
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 排序类型

 - ECSortType_time: 按时间排序(只有降序)
 - ECSortType_sales: 按销量排序(只有降序)
 - ECSortType_price: 按价格排序
 */
typedef NS_ENUM(NSInteger, ECSortType) {
    ECSortType_time = 0,
    ECSortType_sales,
    ECSortType_price
};

/**
 排序顺序

 - ECSortDescType_asc: 升序
 - ECSortDescType_desc: 降序
 */
typedef NS_ENUM(NSInteger, ECSortDescType) {
    ECSortDescType_asc = 0,
    ECSortDescType_desc,
};

@interface ECMallFilterView : UIView

/**
 点击切换排序类型回调
 */
@property (nonatomic, copy) void(^sortTypeClickBlock)(ECSortType sortType);
@property (nonatomic, copy) void(^filterBtnClick)();
/**
 排序类型
 */
@property (nonatomic, assign) ECSortType sortType;
/**
 排序顺序
 */
@property (nonatomic, assign) ECSortDescType sortDescType;
/**
 是否隐藏筛选
 */
@property (nonatomic, assign) BOOL isHideFilter;

@end
