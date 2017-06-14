//
//  ECLogsTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECWorksModel.h"

@interface ECLogsTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECLogsModel *model;

//当为自己的作品时  进行删除
@property (nonatomic, assign) BOOL isUserDelete;

@property (nonatomic, copy) void (^deleteUserBlock)(NSString *worksID,NSInteger row);

@end
