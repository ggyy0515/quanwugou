//
//  ECCommentOrderCell.h
//  B2CEC
//
//  Created by Tristan on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseCollectionViewCell.h"

@class ECOrderProductModel;

@interface ECCommentOrderCell : CMBaseCollectionViewCell

@property (nonatomic, strong) ECOrderProductModel *model;

- (void)setStarLevel:(NSString *)starLevel;

- (void)setComment:(NSString *)comment;

@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, strong) NSMutableArray <ZLSelectPhotoModel *> *lastSelectArray;


/**
 改变评分的回调
 */
@property (nonatomic, copy) void(^starLevelChanged)(NSString *starValue, NSIndexPath *indexPath);
/**
 评论改变的回调
 */
@property (nonatomic, copy) void(^commentChanged)(NSString *comment, NSIndexPath *indexPath);
/**
 添加图片操作
 */
@property (nonatomic, copy) void(^addImageAction)(NSIndexPath *);

@end
