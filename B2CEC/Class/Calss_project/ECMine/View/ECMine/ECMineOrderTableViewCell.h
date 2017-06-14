//
//  ECMineOrderTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECMineModel.h"

@interface ECMineOrderTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECMineModel *model;

@property (copy,nonatomic) void (^orderTypeBlock)(NSInteger type);

@end
