//
//  ECWorksDetailUserInfoTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECWorksModel.h"

@interface ECWorksDetailUserInfoTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECWorksDetailModel *model;

@end
