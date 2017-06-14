//
//  ECBrandStoryWebCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"


@interface ECBrandStoryWebCell : CMBaseTableViewCell

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) void(^didLoadWenHeight)(CGFloat);

@property (nonatomic, copy) void(^clickCheckMore)();

@end
