//
//  ECHomeCityTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECHomeCityTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *city;

@end
