//
//  ECMallPanicBuyCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECMallPanicBuyProductModel;

@interface ECMallPanicBuyCell : CMBaseCollectionViewCell

@property (nonatomic, copy) NSArray <ECMallPanicBuyProductModel *> *dataSource;

@end
