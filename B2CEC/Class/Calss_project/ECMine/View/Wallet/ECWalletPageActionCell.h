//
//  ECWalletPageActionCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECWalletPageActionCell : CMBaseCollectionViewCell

@property (nonatomic, copy) void(^clickCashBtn)();
@property (nonatomic, copy) void(^clickCardBtn)();

@end
