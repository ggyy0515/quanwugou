//
//  ECMallAllView.h
//  B2CEC
//
//  Created by Tristan on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECMallTagModel;

@interface ECMallAllView : UIView

@property (nonatomic, copy) void(^didClickFloor)(NSString *attrCode, NSString *attrValue, NSString *code);

- (void)setCycleDataSource:(NSMutableArray *)cycleDataSource
            houseDataSouce:(NSMutableArray *)houseDataSouce
        PanicBuyDataSource:(NSMutableArray *)panicBuyDataSource
           floorDataSource:(NSMutableArray *)floorDataSource;

- (void)endRefresh;


@end
