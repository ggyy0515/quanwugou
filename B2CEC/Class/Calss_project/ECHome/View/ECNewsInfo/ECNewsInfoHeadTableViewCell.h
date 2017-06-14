//
//  ECNewsInfoHeadTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECNewsCommentModel.h"

@interface ECNewsInfoHeadTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECNewsInfomationModel *model;

@property (copy,nonatomic) void (^focusClickBlock)(BOOL isFocus);

@end
