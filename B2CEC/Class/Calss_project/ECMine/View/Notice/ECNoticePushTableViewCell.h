//
//  ECNoticePushTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
@class ECNoticePushModel;

@interface ECNoticePushTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECNoticePushModel *model;

@property (assign,nonatomic) BOOL isShowAll;

@property (copy,nonatomic) void (^showAllBlock)(NSInteger row);

@end
