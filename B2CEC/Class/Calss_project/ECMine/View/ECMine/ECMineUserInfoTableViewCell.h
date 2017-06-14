//
//  ECMineUserInfoTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECMineModel.h"

@interface ECMineUserInfoTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign,nonatomic) NSInteger type;

@property (strong,nonatomic) ECMineModel *model;

@end
