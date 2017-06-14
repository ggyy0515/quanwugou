//
//  ECMineTitleTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECMineTitleTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setIconImage:(NSString *)iconImage WithTitle:(NSString *)title;

@property (strong,nonatomic) NSString *detailTitle;

@property (strong,nonatomic) UIFont *titleFont;

@property (strong,nonatomic) UIFont *detailFont;

@property (assign,nonatomic) BOOL showDir;

@property (assign,nonatomic) BOOL showRedRound;

@end
