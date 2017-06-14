//
//  ECNewsCommentModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECHomeNewsImageListModel;

@interface ECNewsRecommendModel : NSObject

@property (strong,nonatomic) NSString *classify;

@property (strong,nonatomic) NSString *newsID;

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *type;

@property (strong,nonatomic) NSString *resource;

@end

@interface ECNewsInfomationModel : NSObject

@property (strong,nonatomic) NSString *Boo;

@property (strong,nonatomic) NSString *commentNum;

@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) NSString *createdate;

@property (strong,nonatomic) NSString *newsid;

@property (strong,nonatomic) NSString *iscollect;

@property (strong,nonatomic) NSString *isoriginal;

@property (strong,nonatomic) NSString *praise;

@property (strong,nonatomic) NSString *praiseType;

@property (strong,nonatomic) NSString *resource;

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *type;

@property (strong,nonatomic) NSString *videolength;

@property (strong,nonatomic) NSString *viewNumber;

@property (strong,nonatomic) NSString *videoUrl;

@property (strong,nonatomic) NSString *getContentUrl;

@property (strong,nonatomic) NSString *isattention;

@property (strong,nonatomic) NSArray<ECHomeNewsImageListModel *> *imageList;

@end

@interface ECNewsCommentModel : NSObject

@property (strong,nonatomic) NSString *information_id;

@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) NSString *commentID;

@property (strong,nonatomic) NSString *user_id;

@property (strong,nonatomic) NSString *edittime;

@property (strong,nonatomic) NSString *title_img;

@property (strong,nonatomic) NSString *name;

@end
