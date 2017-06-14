//
//  ECUserInfomationTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/6.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECUserInfoModel.h"

@interface ECUserInfomationTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECUserInfoModel *model;

@end
