//
//  ECHomeAdvertisingTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECHomeAdvertisingTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *imageUrl;

@property (strong,nonatomic) NSString *title;

@end
