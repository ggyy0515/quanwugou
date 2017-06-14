//
//  ECMallTagView.h
//  B2CEC
//
//  Created by Tristan on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECMallTagModel;

@interface ECMallTagView : UIView

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray <ECMallTagModel *> *dataSource;
/**
 选择了某个分类
 */
@property (nonatomic, copy) void(^didSelectCatAtIndex)(NSInteger index);

+ (instancetype)showTagInView:(UIView *)view dataSource:(NSMutableArray *)dataSource;

/**
 滚动到某个分类

 @param index 序号
 */
- (void)scrollToIndex:(NSInteger)index;

@end
