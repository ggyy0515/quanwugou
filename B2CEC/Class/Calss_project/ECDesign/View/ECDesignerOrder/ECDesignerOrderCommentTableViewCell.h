//
//  ECDesignerOrderCommentTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECDesignerOrderCommentTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *iconImage;

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSArray *imageArray;

@property (nonatomic, copy) void(^starLevelChanged)(NSString *starValue);

@property (nonatomic, copy) void(^commentChanged)(NSString *comment);

@property (copy,nonatomic) void (^imageClickBlock)(NSInteger index);

@property (copy,nonatomic) void (^addImageClickBlock)();

@end
