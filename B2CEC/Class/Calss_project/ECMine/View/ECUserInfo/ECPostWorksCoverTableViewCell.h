//
//  ECPostWorksCoverTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECPostWorksCoverTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) UIImage *coverImage;

@property (copy,nonatomic) void (^selectCoverBlock)();

@end
