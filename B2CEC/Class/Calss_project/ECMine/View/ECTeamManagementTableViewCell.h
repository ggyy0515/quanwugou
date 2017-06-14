//
//  ECTeamManagementTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "SWTableViewCell.h"
#import "ECTeamModel.h"

@interface ECTeamManagementTableViewCell : SWTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECTeamModel *model;

@property (assign,nonatomic) BOOL isShowNext;

@end
