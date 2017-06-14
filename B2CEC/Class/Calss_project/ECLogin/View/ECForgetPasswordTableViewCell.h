//
//  ECForgetPasswordTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECForgetPasswordTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (copy,nonatomic) void (^getVerficationBlock)(NSString *mobile);

@property (copy,nonatomic) void (^nextStepBlock)(NSString *mobile,NSString *verfication);

@end
