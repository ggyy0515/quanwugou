//
//  ECConfirmOrderBillInfoCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECConfirmOrderBillInfoCell : CMBaseCollectionViewCell

/**
 是否需要发票开关状态改变
 */
@property (nonatomic, copy) void(^billSateChanged)(BOOL needBill);
/**
 填写的发票信息
 */
@property (nonatomic, copy) void(^didInputBillInfo)(NSString *billInfo);

@end
