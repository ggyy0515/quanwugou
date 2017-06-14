//
//  ECAccountResetTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECAccountResetTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign,nonatomic) NSInteger type;

@property (copy,nonatomic) void (^clickTypeBlock)(NSInteger index);

@end
