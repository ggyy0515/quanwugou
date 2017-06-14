//
//  ECProductAttrViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@class ECProductAttrModel;

@interface ECProductAttrViewController : CMBaseViewController

@property (nonatomic, strong) NSMutableArray <ECProductAttrModel *> *dataSource;

@end
