//
//  ECMallFilterViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"

@interface ECMallFilterViewController : CMBaseTableViewController

/*!
 *  分类编码
 */
@property (copy, nonatomic) NSString *catCode;
/**
 场馆编码
 */
@property (nonatomic, copy) NSString *houseCode;
///**
// 是否需要包含场馆数据
// */
//@property (nonatomic, assign) BOOL includeHouse;

@property (nonatomic, copy) NSString *attrs;

- (void)clearFilter;

/*!
 *  点击确认筛选条件，返回列表页重新搜索商品结果 (重置筛选条件回调也回调此block)
 */
@property (copy,nonatomic) void (^submitFiltrateClick)(CGFloat minPrice, CGFloat maxPrice, NSString *attrs, NSString *sHousecode, NSString *secondType);


@end
