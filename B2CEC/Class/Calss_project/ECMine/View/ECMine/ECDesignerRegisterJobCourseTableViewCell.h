//
//  ECDesignerRegisterJobCourseTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/30.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECDesignerRegisterJobCourseTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *placepolder;

@property (strong,nonatomic) NSString *content;

@property (copy,nonatomic) void (^courseTextChangeBlock)(NSString *course);

@end