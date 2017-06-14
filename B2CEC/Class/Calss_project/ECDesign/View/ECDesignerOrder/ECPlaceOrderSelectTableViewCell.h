//
//  ECPlaceOrderSelectTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECPlaceOrderSelectTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *type;

@property (strong,nonatomic) NSArray *nameArray;

@property (strong,nonatomic) NSArray *dataArray;

@property (assign,nonatomic) NSInteger currentIndex;

@property (copy,nonatomic) void (^currentModelBlock)(NSString *name,NSString *bianma);

@end
