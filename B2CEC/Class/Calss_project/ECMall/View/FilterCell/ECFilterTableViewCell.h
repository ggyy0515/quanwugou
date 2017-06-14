//
//  ECFilterTableViewCell.h
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

typedef NS_ENUM(NSInteger, ConditionCellType) {
    ConditionCellType_house = 0,
    ConditionCellType_secondType,
    ConditionCellType_other
};

@interface ECFilterTableViewCell : CMBaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView conditionType:(ConditionCellType)type;


@property (assign,nonatomic) NSInteger currentIndex;

@property (copy,nonatomic) void (^currentClick)(NSInteger currentIndex, ConditionCellType cellType);

/**
 场馆时使用
 */
@property (nonatomic, strong) NSArray *houseDataSource;
/**
 二级分类时使用
 */
@property (nonatomic, strong) NSArray *secondTypeDataSource;
/**
 其他搜索条件时使用
 */
@property (strong,nonatomic) NSArray *dataArray;



@end
