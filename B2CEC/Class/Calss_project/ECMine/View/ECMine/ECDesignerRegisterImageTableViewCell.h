//
//  ECDesignerRegisterImageTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/30.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECDesignerRegisterImageTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) UIImage *iconImage;

@property (strong,nonatomic) NSString *iconImageUrl;

@property (strong,nonatomic) NSIndexPath *indexpath;

@property (assign,nonatomic) BOOL isFlag;

@property (copy,nonatomic) void (^deleteImageBlock)(NSInteger row);

@property (copy,nonatomic) void (^getImageSizeBlock)(NSInteger row,CGFloat height);

@end
