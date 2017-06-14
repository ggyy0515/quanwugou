//
//  ECLogisticsOrderCell.h
//  B2CEC
//
//  Created by 曙华 on 16/7/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECLogisticsOrderCell : CMBaseTableViewCell
/**
 *  图片url
 */
@property (nonatomic, copy) NSString *imageUrl;
/**
 *  物流单号
 */
@property (nonatomic, copy) NSString *logisticsNum;
/**
 *  物流状态
 */
@property (nonatomic, copy) NSString *logisticsState;
/**
 *  快递公司
 */
@property (nonatomic, copy) NSString *express;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
