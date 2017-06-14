//
//  ECBankCardListCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "SWTableViewCell.h"

@class ECBankCardListModel;

@interface ECBankCardListCell : SWTableViewCell

@property (nonatomic, strong) ECBankCardListModel *model;

@end
