//
//  ECMallHouseViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@interface ECMallHouseViewController : CMBaseViewController

/**
 馆的编码 这个编码还可以用作可变的筛选条件
 */
@property (nonatomic, copy) NSString *houseCode;
/**
 是否是特价馆
 */
@property (nonatomic, assign) BOOL isBarginPriceHouse;

@end
