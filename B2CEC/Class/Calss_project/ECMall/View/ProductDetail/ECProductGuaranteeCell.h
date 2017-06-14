//
//  ECProductGuaranteeCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECProductGuaranteeCell : CMBaseCollectionViewCell

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, copy) void(^didGetCellHeight)(CGFloat height);

@end
