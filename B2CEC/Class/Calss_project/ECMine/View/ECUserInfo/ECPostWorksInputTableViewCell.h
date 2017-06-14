//
//  ECPostWorksInputTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECPostWorksInputTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setName:(NSString *)name WithPlaceholder:(NSString *)placeholder;

@property (copy,nonatomic) void (^selectTypeBlock)(NSString *bianma);

@end
