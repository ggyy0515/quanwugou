//
//  ECAccountResetPasswordTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECAccountResetPasswordTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *tips;

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSString *placeholder;

@property (strong,nonatomic) NSString *submitStr;

@property (strong,nonatomic) NSString *bottomTips;

@property (assign,nonatomic) BOOL isSecureTextEntry;

@property (copy,nonatomic) void (^nextStepBlock)(NSString *password);

@end
