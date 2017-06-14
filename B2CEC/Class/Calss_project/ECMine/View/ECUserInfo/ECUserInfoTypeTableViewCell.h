//
//  ECUserInfoTypeTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/6.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECUserInfoTypeTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign,nonatomic) BOOL isDesigner;

@property (assign,nonatomic) NSInteger type;

@property (copy,nonatomic) void (^typeClickBlock)(NSInteger index);

@end
