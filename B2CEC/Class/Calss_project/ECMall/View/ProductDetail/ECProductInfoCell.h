//
//  ECProductInfoCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECProductInfoModel;

@interface ECProductInfoCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECProductInfoModel *model;

@end
