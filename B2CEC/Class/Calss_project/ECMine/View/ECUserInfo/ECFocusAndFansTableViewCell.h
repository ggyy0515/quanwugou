//
//  ECFocusAndFansTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECFocusAndFansModel.h"

@interface ECFocusAndFansTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECFocusAndFansModel *model;

@property (copy,nonatomic) void (^focusClickBlock)(NSInteger indexRow);

@end
