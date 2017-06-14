//
//  ECWalletBillListModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECWalletBillListModel : NSObject

/**
 金额
 */
@property (nonatomic, copy) NSString *amount;
/**
 流水账类型:0-购买商品,1-银行卡提现,2-平台退款,3-积分兑换零钱
 */
@property (nonatomic, copy) NSString *type;
/**
 主键
 */
@property (nonatomic, copy) NSString *ids;
/**
 创建时间
 */
@property (nonatomic, copy) NSString *createDate;
/**
 说明
 */
@property (nonatomic, copy) NSString *detail;
/**
 带符号金额
 */
@property (nonatomic, copy) NSString *symbolAmount;
/**
 图片
 */
@property (nonatomic, copy) NSString *image;

@end
