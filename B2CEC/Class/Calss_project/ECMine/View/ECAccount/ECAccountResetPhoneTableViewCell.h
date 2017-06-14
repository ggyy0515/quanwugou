//
//  ECAccountResetPhoneTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECAccountResetPhoneTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *tips;

@property (strong,nonatomic) NSString *submitStr;

@property (copy,nonatomic) void (^nextStepBlock)(NSString *password);

@property (copy,nonatomic) void (^getVerficationBlock)();

@end
