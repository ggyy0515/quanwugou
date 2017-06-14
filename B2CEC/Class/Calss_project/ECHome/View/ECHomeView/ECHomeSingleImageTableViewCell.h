//
//  ECHomeSingleImageTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECHomeNewsListModel.h"

@interface ECHomeSingleImageTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECHomeNewsListModel *model;

//是否可删除
@property (nonatomic, assign) BOOL isDelete;
//点击删除的回调
@property (nonatomic, copy) void (^deleteBlock)(NSString *collectID,NSInteger row);

@end

