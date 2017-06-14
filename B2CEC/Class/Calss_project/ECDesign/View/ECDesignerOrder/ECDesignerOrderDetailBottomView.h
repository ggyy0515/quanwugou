//
//  ECDesignerOrderDetailBottomView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECDesignerModel.h"

@interface ECDesignerOrderDetailBottomView : UIView

@property (assign,nonatomic) BOOL isDesigner;

@property (strong,nonatomic) ECDesignerOrderDetailModel *model;

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
@property (copy,nonatomic) void (^clickOperationBlock)(NSInteger type);

@end
