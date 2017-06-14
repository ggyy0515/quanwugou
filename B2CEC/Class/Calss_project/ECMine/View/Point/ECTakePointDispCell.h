//
//  ECTakePointDispCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECPointInfoModel;

@interface ECTakePointDispCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECPointInfoModel *model;
@property (nonatomic, copy) NSString *point;

@end
