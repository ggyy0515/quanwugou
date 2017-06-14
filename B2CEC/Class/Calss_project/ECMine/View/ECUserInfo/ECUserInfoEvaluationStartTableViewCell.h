//
//  ECUserInfoEvaluationStartTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/19.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECUserInfoEvaluationStartTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *score;

@end
