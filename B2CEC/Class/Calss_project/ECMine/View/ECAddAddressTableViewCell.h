//
//  ECAddAddressTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECAddressModel.h"

@interface ECAddAddressTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECAddressModel *model;

@property (strong,nonatomic) NSString *address;

@property (copy,nonatomic) void (^selectCityBlock)();

@property (copy,nonatomic) void (^saveAddressBlock)(NSString *name,NSString *phone,NSString *address,NSString *addressDetail,BOOL isDefaults);

@end
