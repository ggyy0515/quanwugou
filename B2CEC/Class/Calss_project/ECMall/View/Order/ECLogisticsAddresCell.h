//
//  ECLogisticsAddresCell.h
//  B2CEC
//
//  Created by 曙华 on 16/7/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECLogisticsAddresCell : CMBaseTableViewCell
/**
 *  字体颜色
 */
@property (nonatomic, copy) UIColor *textColor;
/**
 *  小圆圈图片
 */
@property (nonatomic, strong) UIImageView *imageV;
/**
 *  地址
 */
@property (nonatomic, strong) UILabel *addressLabel;
/**
 *  时间
 */
@property (nonatomic, strong) UILabel *dateLabel;
/**
 *  顶部连接线
 */
@property (nonatomic, strong) UIView *topLine;
/**
 *  底部的连接线
 */
@property (nonatomic, strong) UIView *bottomLine;
/**
 *  默认/第一/最后  0/1/2
 */
@property (nonatomic, assign) NSInteger isFristOrFinall;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
