//
//  ECAddCardInfoCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECAddCardInfoCell : CMBaseCollectionViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, copy) void(^contentChanged)(NSIndexPath *, NSString *);
@property (nonatomic, strong) UIView *line;

@end
