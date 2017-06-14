//
//  ECNewsInfoHtmlTableViewCell.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@interface ECNewsInfoHtmlTableViewCell : CMBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)loadHtmlWithConntent:(NSString *)webContent WithNeed:(BOOL)isNeedLoadHtml;

@property (copy,nonatomic) void (^loadHtmlHeightBlock)(CGFloat height);

@end
