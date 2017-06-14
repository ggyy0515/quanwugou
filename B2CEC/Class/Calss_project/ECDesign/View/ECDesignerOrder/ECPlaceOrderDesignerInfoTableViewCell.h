//
//  ECPlaceOrderDesignerInfoTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECPlaceOrderDesignerInfoTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *designerName;

@property (strong,nonatomic) NSString *designerTitleImage;

@end
