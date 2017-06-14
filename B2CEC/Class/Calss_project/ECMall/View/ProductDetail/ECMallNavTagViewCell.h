//
//  ECMallNavTagViewCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECMallNavTagViewCell : CMBaseCollectionViewCell

@property (nonatomic, copy) NSString *title;
/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 选中时候的底部线条
 */
@property (nonatomic, strong) UILabel *line;

@end
