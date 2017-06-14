//
//  ECSettingPayPasswordTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECSettingPayPasswordTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (copy,nonatomic) void (^confirmBlock)(NSString *password);

@end
