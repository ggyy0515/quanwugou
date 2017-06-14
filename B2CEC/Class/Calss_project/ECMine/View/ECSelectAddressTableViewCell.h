//
//  ECSelectAddressTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECAddressModel.h"

@interface ECSelectAddressTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setModel:(ECAddressModel *)model WithAddressID:(NSString *)addressID;

@property (copy,nonatomic) void (^selectAddressBlock)(ECAddressModel *model);

@end
