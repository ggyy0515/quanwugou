//
//  ECDesignerTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECDesignerModel.h"

@interface ECDesignerTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECDesignerModel *model;

@property (copy,nonatomic) void (^focusClickBlock)(NSInteger indexRow);

@end
