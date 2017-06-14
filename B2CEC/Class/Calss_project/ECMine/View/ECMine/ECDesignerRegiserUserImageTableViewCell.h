//
//  ECDesignerRegiserUserImageTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECDesignerRegiserUserImageTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) UIImage *iconImage;

@property (strong,nonatomic) NSString *iconImageUrl;

@end
