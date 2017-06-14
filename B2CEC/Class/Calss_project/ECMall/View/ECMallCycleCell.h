//
//  ECMallCycleCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class SDCycleScrollView;
@class ECMallCycleViewModel;

@interface ECMallCycleCell : CMBaseCollectionViewCell

/**
 *  滚动图
 */
@property (nonatomic, strong) SDCycleScrollView *cycleView;
/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray <ECMallCycleViewModel *> *cycleViewDataSource;

@end
