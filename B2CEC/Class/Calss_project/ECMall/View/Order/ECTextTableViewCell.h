//
//  ECTextTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 16/7/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECTextTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (copy,nonatomic) NSString *name;

@property (copy,nonatomic) NSString *detail;

@property (strong,nonatomic) UIColor *nameColor;

@property (strong,nonatomic) UIColor *detailColor;

@property (assign,nonatomic) CGFloat nameFont;

@property (assign,nonatomic) CGFloat detailFont;

@property (assign,nonatomic) NSInteger nameNumberOfLines;

@property (assign,nonatomic) NSTextAlignment textAlignment;

@property (assign,nonatomic) BOOL showLine;


@end
