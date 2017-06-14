//
//  ECDesignerOrderDetailUserInfoTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECDesignerModel.h"

@interface ECDesignerOrderDetailUserInfoTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign,nonatomic) BOOL isDesigner;

@property (strong,nonatomic) ECDesignerOrderDetailModel *model;

@property (copy,nonatomic) void (^chatClickBlock)();

@end
