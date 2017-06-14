//
//  ECFilterPriceTableViewCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECFilterPriceTableViewCell : CMBaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView isPickDate:(BOOL)isPickDate;

@property (copy,nonatomic) NSString *leftString;

@property (copy,nonatomic) NSString *rightString;

@property (assign,nonatomic) CGFloat minPrice;

@property (assign,nonatomic) CGFloat maxPrice;

@property (copy,nonatomic) void (^changePriceBlock)(CGFloat minPrice,CGFloat maxPrice);

@property (nonatomic, copy) void(^changeDateBlock)(NSString *start, NSString *end);

@end
