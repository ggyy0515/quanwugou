//
//  ECPointProductDetailWebCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECPointProductDetailWebCell : CMBaseCollectionViewCell

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) void(^didLoadWenHeight)(CGFloat cellHeight);

@end
