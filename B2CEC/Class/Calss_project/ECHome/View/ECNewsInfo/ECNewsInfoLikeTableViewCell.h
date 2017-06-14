//
//  ECNewsInfoLikeTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECNewsInfoLikeTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *praiseType;

@property (strong,nonatomic) NSString *praise;

@property (strong,nonatomic) NSString *boo;

@property (copy,nonatomic) void (^praiseClickBlock)(BOOL isLike);

@property (copy,nonatomic) void (^reportClickBlock)();

@end
