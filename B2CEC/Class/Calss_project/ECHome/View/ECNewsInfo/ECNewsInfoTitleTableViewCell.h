//
//  ECNewsInfoTitleTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECNewsInfoTitleTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign,nonatomic) BOOL isHiddenTitle;

@property (strong,nonatomic) NSString *title;

@end
