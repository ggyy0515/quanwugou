//
//  ECPointManagmentActionCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECPointManagmentActionCell : CMBaseCollectionViewCell

@property (nonatomic, copy) void(^leftBtnClick)();
@property (nonatomic, copy) void(^rightBtnClick)();

@end
