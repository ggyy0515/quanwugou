//
//  ECUserInfoDesignerResumeTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/6.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECUserInfoDesignerResumeTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)loadHtmlWithConntent:(NSString *)webContent WithNeed:(BOOL)isNeedLoadHtml;

@property (copy,nonatomic) void (^loadHtmlHeightBlock)(CGFloat height);

@end
