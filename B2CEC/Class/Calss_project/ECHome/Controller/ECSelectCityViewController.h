//
//  ECSelectCityViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"
#import "ECCityModel.h"

@interface ECSelectCityViewController : CMBaseTableViewController

/**
 如果传入此值，则不会向服务器请求城市数据
 */
@property (strong,nonatomic) ECCityModel *model;
//0:资讯城市  1：商城城市 2:设计城市
@property (assign,nonatomic) NSInteger type;

@property (copy,nonatomic) void (^selectCityBlock)(ECCityModel *model,ECCityModel *detailModel);

@end
