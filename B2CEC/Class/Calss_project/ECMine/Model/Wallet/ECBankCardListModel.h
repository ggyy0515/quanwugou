//
//  ECBankCardListModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECBankCardListModel : NSObject

/**
 银行卡ID
 */
@property (nonatomic, copy) NSString *bankId;
/**
 银行卡号
 */
@property (nonatomic, copy) NSString *bankNo;
/**
 银行卡图标
 */
@property (nonatomic, copy) NSString *image;
/**
 银行卡名称
 */
@property (nonatomic, copy) NSString *bankName;
/**
 是否是默认:0-否,1-是
 */
@property (nonatomic, copy) NSString *isDefault;

@end
