//
//  ECCommentOrderPicCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@interface ECCommentOrderPicCell : CMBaseCollectionViewCell

/**
 点击删除按钮回调
 */
@property (nonatomic, copy) void(^clickDeleteBtn)(NSIndexPath *);
@property (nonatomic, strong) UIImage *image;

@property (strong,nonatomic) NSString *imageUrl;

@property (assign,nonatomic) BOOL showDelete;

@end
