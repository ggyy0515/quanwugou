//
//  ECPostLogsImageListTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECPostLogsImageListTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSArray *imageArray;

@property (assign,nonatomic) CGSize itemSize;

@property (strong,nonatomic) NSString *addImage;

@property (copy,nonatomic) void (^imageClickBlock)(NSInteger index);

@property (copy,nonatomic) void (^addImageClickBlock)();

@end
