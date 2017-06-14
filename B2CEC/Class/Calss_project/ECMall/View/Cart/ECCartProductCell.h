//
//  ECCartProductCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@class ECCartProductModel;

@interface ECCartProductCell : CMBaseTableViewCell

@property (nonatomic, strong) ECCartProductModel *model;
@property (nonatomic, copy) void(^clickSelectBtn)();
@property (nonatomic, copy) void(^changeCountBlock)();

@end
