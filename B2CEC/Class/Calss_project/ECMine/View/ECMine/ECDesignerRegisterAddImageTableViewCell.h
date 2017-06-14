//
//  ECDesignerRegisterAddImageTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/30.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECDesignerRegisterAddImageTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (copy,nonatomic) void (^addImageBlock)();

@end
