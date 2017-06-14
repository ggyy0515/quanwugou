//
//  ECConfirmOrderQcodeCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/1.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECConfirmOrderQcodeCell : CMBaseCollectionViewCell

/**
 选择是否使用Q码
 */
@property (nonatomic, copy) void(^useQCodel)(BOOL useQCode);
/**
 取得Q码是否可用的回调
 */
@property (nonatomic, copy) void(^didLoadQcodeValidState)(NSString *qcode, BOOL isValid);

/**
 Q码，用于保存输入过的Q码
 */
@property (nonatomic, copy) NSString *qCode;

@end
