//
//  ECOrderCommentTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2017/1/18.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECOrderCommentModel.h"

@interface ECOrderCommentTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECOrderCommentModel *model;

@end
