//
//  ECDesignerScreenView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECDesignerScreenView : UIView

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *titleArray;

@property (strong,nonatomic) NSArray *dataArray;

@property (assign,nonatomic) NSInteger type;

@property (copy,nonatomic) void (^clickTitleBlock)(NSInteger index);

@property (copy,nonatomic) void (^selectTypeBlock)();

- (void)hidden;

@end
