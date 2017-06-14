//
//  ECMoreProductViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/11/24.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@interface ECMoreProductViewController : CMBaseViewController

@property (nonatomic, copy) void(^didClickProductAtIndex)(NSInteger, UICollectionViewCell *);

/**
 构造 方法

 @param dataSource 数据源
 @return 实例对象
 */
- (instancetype)initWithDataSource:(NSMutableArray *)dataSource;


@end
