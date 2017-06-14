//
//  ECChatListCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewCell.h"

@class ECChatListModel;

@interface ECChatListCell : CMBaseTableViewCell

@property (nonatomic, strong) ECChatListModel *model;

@end
