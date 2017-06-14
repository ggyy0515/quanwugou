//
//  ECSelectCityTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECCityModel.h"

@interface ECSelectCityTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECCityModel *model;

@end
