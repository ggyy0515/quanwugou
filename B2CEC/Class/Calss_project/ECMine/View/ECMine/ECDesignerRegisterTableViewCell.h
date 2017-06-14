//
//  ECDesignerRegisterTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECDesignerRegisterTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign,nonatomic) BOOL isInput;

@property (strong,nonatomic) NSIndexPath *indexpath;

@property (strong,nonatomic) NSString *dataStr;
//0:性别  1：生日  2：电话号码  3：收费标准  4:擅长风格  5:职业
@property (assign,nonatomic) NSInteger keyboardType;

@property (strong,nonatomic) NSArray *jobsArray;

@property (copy,nonatomic) void (^changeDataBlock)(NSIndexPath *indexpath,NSString *text);
//选择擅长风格之后
@property (copy,nonatomic) void (^changeStyleBlock)(NSIndexPath *indexpath,NSString *name,NSString *bianma);
//选择职业之后
@property (copy,nonatomic) void (^changeJobsBlock)(NSIndexPath *indexpath,NSString *name,NSString *bianma);

- (void)setName:(NSString *)name WithPlaceholder:(NSString *)placeholder;

@end
