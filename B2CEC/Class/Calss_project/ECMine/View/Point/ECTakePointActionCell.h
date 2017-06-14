//
//  ECTakePointActionCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECPointInfoModel;

@interface ECTakePointActionCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECPointInfoModel *model;
@property (nonatomic, copy) void(^clickAllBtn)();
@property (nonatomic, copy) void(^clickConfirmBtn)();


@end
