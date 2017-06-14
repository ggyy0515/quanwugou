//
//  ECNewsInfoCommentTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECNewsCommentModel.h"

@interface ECNewsInfoCommentTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *title_img;

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSString *edittime;

@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) NSString *userID;

@property (copy,nonatomic) void (^iconClickBlock)(NSString *userID);

@end
