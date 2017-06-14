//
//  ECDesignerScreenTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECDesignerScreenTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *title;

@property (assign,nonatomic) BOOL isSelect;

@end
