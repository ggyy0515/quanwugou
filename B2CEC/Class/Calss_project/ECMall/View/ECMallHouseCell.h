//
//  ECMallHouseCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECMallHouseModel;

@interface ECMallHouseCell : CMBaseCollectionViewCell

@property (nonatomic, strong) NSArray <ECMallHouseModel *> *dataSource;

@end
