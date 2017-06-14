//
//  ECAddressManagementTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECAddressModel.h"

@interface ECAddressManagementTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECAddressModel *model;

@property (strong,nonatomic) void (^defaultAdressClickBlock)(ECAddressModel *model);

@property (strong,nonatomic) void (^editAdressClickBlock)(ECAddressModel *model);

@property (strong,nonatomic) void (^deleteAdressClickBlock)(ECAddressModel *model);

@end
