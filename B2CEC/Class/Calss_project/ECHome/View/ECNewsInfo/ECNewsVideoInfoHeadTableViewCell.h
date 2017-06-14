//
//  ECNewsVideoInfoHeadTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECNewsCommentModel.h"

@interface ECNewsVideoInfoHeadTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECNewsInfomationModel *mode;

@property (copy,nonatomic) void (^praiseClickBlock)(BOOL isLike);

@property (copy,nonatomic) void (^focusClickBlock)(BOOL isFocus);

@property (copy,nonatomic) void (^reportClickBlock)();

@end
