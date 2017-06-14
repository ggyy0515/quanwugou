//
//  ECUserInfoHeaderTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECUserInfoModel.h"

@interface ECUserInfoHeaderTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECUserInfoModel *model;

@property (assign,nonatomic) BOOL isEdit;

@property (copy,nonatomic) void (^typeClickBlock)(NSInteger type);

@property (copy,nonatomic) void (^editInfoBlock)();

@end
