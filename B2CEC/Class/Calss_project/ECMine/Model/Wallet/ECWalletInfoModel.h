//
//  ECWalletInfoModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECWalletInfoModel : NSObject

/**
 账户零钱
 */
@property (nonatomic, copy) NSString *balance;
/**
 是否已经改变(小红花的提示时根据此字段):0-否,1-是
 */
@property (nonatomic, copy) NSString *hasChange;
/**
 账户ID
 */
@property (nonatomic, copy) NSString *ids;


@end
