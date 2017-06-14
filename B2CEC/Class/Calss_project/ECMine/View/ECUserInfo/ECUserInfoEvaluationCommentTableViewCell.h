//
//  ECUserInfoEvaluationCommentTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/19.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECUserInfoCommentModel.h"

@interface ECUserInfoEvaluationCommentTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECUserInfoCommentModel *model;

@end
