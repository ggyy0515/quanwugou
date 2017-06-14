//
//  ECSettingSwitchTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/1.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECSettingSwitchTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *name;

@property (assign,nonatomic) BOOL on;

@property (copy,nonatomic) void (^switchChangeBlock)(BOOL on);

@end
