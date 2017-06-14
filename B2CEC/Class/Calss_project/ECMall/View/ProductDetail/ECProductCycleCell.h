//
//  ECProductCycleCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class SDCycleScrollView;

@interface ECProductCycleCell : CMBaseCollectionViewCell

/**
 *  滚动图
 */
@property (nonatomic, strong) SDCycleScrollView *cycleView;
/**
 *  圆label
 */
@property (nonatomic, strong) UILabel *roundLabel;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, copy) NSArray *imageUrlArr;

@property (nonatomic, copy) void (^moreBtnClick)();

@end
