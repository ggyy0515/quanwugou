//
//  ECLoginTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECLoginTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (copy,nonatomic) void (^loginBlock)(NSString *mobile,NSString *password);

@property (copy,nonatomic) void (^weixinLoginBlock)();

@property (copy,nonatomic) void (^qqLoginBlock)();

@property (copy,nonatomic) void (^registerBlock)();

@property (copy,nonatomic) void (^forgetPasswordBlock)();

@end
