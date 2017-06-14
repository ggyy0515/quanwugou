//
//  SHImageListView.h
//  ZhongShanEC
//
//  Created by 曙华国际 on 16/6/2.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHImageListView : UIView
/*!
 *  图片集合
 */
@property (strong,nonatomic) NSArray *imageArray;
/*!
 *  新增的图片
 */
@property (strong,nonatomic) NSArray *addImageArray;
/*!
 *  图片大小（defaults：60*60）
 */
@property (assign,nonatomic) CGSize itemSize;
/**
 添加图片名字
 */
@property (strong,nonatomic) NSString *addImage;
/*!
 *  是否存在添加按钮
 */
@property (assign,nonatomic) BOOL isAdd;
/*!
 *  当传入图片为路径时，指明图片所在字典路径
 *  需在申明图片集合之前申明
 */
@property (strong,nonatomic) NSArray *urlKeyArray;
/*!
 *  图片最大数量值，达到时不显示添加图片按钮
 *  需在申明图片集合之前申明
 *  不传或者为零  则表示一直显示添加图片按钮
 */
@property (assign,nonatomic) NSInteger maxCount;
/*!
 *  可添加状态下点击图片，返回点击的下标
 */
@property (copy,nonatomic) void (^imageClickBlock)(NSInteger index);
/*!
 *  点击添加图片
 */
@property (copy,nonatomic) void (^addImageClickBlock)();
/*!
 *  返回所需高度
 *
 *  @param width    最大的宽度
 *  @param count    数组数量
 *  @param max      最大图片数量  为0则表示一直显示添加图片按钮
 *  @param itemSize 图片大小
 *  @param isAdd    是否可以添加图片
 *
 *  @return 所需高度
 */
+ (CGFloat)imageListWithMaxWidth:(CGFloat)width
                      WithCount:(NSInteger)count
                    WithMaxCount:(NSInteger)max
                   WithItemSize:(CGSize)itemSize
                        WithAdd:(BOOL)isAdd;
@end
