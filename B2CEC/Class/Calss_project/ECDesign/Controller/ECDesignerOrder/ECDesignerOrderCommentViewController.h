//
//  ECDesignerOrderCommentViewController.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseTableViewController.h"

@interface ECDesignerOrderCommentViewController : CMBaseTableViewController

@property (strong,nonatomic) NSString *orderID;

@property (strong,nonatomic) NSString *designerName;

@property (strong,nonatomic) NSString *designerIconImage;

@property (copy,nonatomic) void (^commentSuccessBlock)();

@end
