//
//  ECTakeMoneyAmountCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECWalletInfoModel;

@interface ECTakeMoneyAmountCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECWalletInfoModel *model;

@property (nonatomic, copy) void(^amountChange)(NSString *amount);

@end
