//
//  ECDesignerOrderDetailContentTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECDesignerOrderDetailContentTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) NSArray *imgUrls;

@end
