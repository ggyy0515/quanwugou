//
//  ECHomeNewsListModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECHomeNewsImageListModel : NSObject

@property (strong,nonatomic) NSString *image;

@property (strong,nonatomic) NSString *orderby;

@property (strong,nonatomic) NSString *title;

@end

@interface ECHomeNewsListModel : NSObject
//资讯类型编码,
@property (strong,nonatomic) NSString *classify;
//评论数量
@property (strong,nonatomic) NSString *commentNum;
//封面图片一,插入的时候取内容的第一张图片;如果是视频的话就是视频的第一帧截图
@property (strong,nonatomic) NSString *cover1;
//封面图片,插入的时候取详情的第二张图片;如果是视频的话就是视频的地址
@property (strong,nonatomic) NSString *cover2;
//封面图片,插入的时候取详情的第三张图片
@property (strong,nonatomic) NSString *cover3;
//资讯发布日期,
@property (strong,nonatomic) NSString *createdate;
//资讯ID,
@property (strong,nonatomic) NSString *newsID;
//用来标示资讯列表的格式0:-单图 1-多图 2-无图 3-大图 4-广告 5-可在列表播放的视频 6-不可在列表播放的视频
@property (strong,nonatomic) NSString *inforType;

@property (strong,nonatomic) NSString *isoriginal;
//资讯来源，中国日报，全屋构这类
@property (strong,nonatomic) NSString *resource;
//资讯标题,
@property (strong,nonatomic) NSString *title;
//类型:0-富文本,1-图片和文字,2-视频,
@property (strong,nonatomic) NSString *type;

@property (strong,nonatomic) NSString *videolength;
//浏览次数
@property (strong,nonatomic) NSString *viewNumber;
//广告链接
@property (strong,nonatomic) NSString *weburl;

@property (strong,nonatomic) NSString *iscollect;

@property (strong,nonatomic) NSString *isView;

@property (strong,nonatomic) NSString *collect_id;

@property (strong,nonatomic) NSArray<ECHomeNewsImageListModel *> *imageList;

@end
