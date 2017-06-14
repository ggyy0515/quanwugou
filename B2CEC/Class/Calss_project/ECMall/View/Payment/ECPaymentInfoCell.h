//
//  ECPaymentInfoCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECCommitOrderInfoModel;

@interface ECPaymentInfoCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECCommitOrderInfoModel *model;

@end
