//
//  ECHomeVideoPlayerTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "SHVideoPlayerView.h"
#import "ECHomeNewsListModel.h"

@interface ECHomeVideoPlayerTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) SHVideoPlayerView *videoPlayerView;

@property (strong,nonatomic) NSIndexPath *indexPath;

@property (strong,nonatomic) ECHomeNewsListModel *model;

@property (copy,nonatomic) void (^startVideoPlayer)(NSIndexPath *indexPath);

@property (copy,nonatomic) void (^shareClickBlock)();

@end
