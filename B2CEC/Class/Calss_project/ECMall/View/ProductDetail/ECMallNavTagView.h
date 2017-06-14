//
//  ECMallNavTagView.h
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECMallNavTagView : UIView

/**
 当前所选中项的序号
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 点击某项的回调
 */
@property (nonatomic, copy) void(^didSelectIndex)(NSInteger index);
/**
 设置数据源和初始选中项

 @param dataSource 数据源
 @param currentIndex 初始选中项
 */
- (void)setDataSource:(NSMutableArray *)dataSource currentIndex:(NSInteger)currentIndex;

/**
 滚到某一项

 @param index 序号
 */
- (void)scrollToIndex:(NSInteger)index;

@end
