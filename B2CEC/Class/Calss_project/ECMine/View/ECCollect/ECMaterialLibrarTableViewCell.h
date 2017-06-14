//
//  ECMaterialLibrarTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"
#import "ECMaterialLibraryModel.h"

@interface ECMaterialLibrarTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ECMaterialLibraryModel *model;
//点击收藏的回调
@property (nonatomic, copy) void (^collectBlock)(NSInteger row);

@end
