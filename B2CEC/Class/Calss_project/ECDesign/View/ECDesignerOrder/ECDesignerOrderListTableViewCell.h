//
//  ECDesignerOrderListTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECDesignerOrderModel.h"

@interface ECDesignerOrderListTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign,nonatomic) BOOL isDesigner;

@property (strong,nonatomic) ECDesignerOrderModel *model;
//0:婉拒
//1：报价接单
//2:取消订单
//3：修改订单
//4:确认订单并支付
//5:设计师确认完工
//6：用户确认完工
//7:用户申请退款
//8:待评价
//9:修改报价
@property (copy,nonatomic) void (^clickOperationBlock)(NSInteger type,NSInteger section);

@end
