//
//  ECWorksModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECWorksCommentModel : NSObject

@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) NSString *commentID;

@property (strong,nonatomic) NSString *edittime;

@property (strong,nonatomic) NSString *title_img;

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSString *case_id;

@property (strong,nonatomic) NSString *user_id;

@end

@interface ECLogsModel : NSObject

@property (strong,nonatomic) NSString *logsID;

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *createdate;

@property (strong,nonatomic) NSString *user_id;

@property (strong,nonatomic) NSArray *imgurl;

@end

@interface ECWorksDetailUserModel : NSObject

@property (strong,nonatomic) NSString *ATTENTION;

@property (strong,nonatomic) NSString *ATTENTION_COUNT;

@property (strong,nonatomic) NSString *FANS_COUNT;

@property (strong,nonatomic) NSString *NAME;

@property (strong,nonatomic) NSString *TITLE_IMG;

@property (strong,nonatomic) NSString *USERINFO_ID;

@property (strong,nonatomic) NSString *USER_ID;

@property (strong,nonatomic) NSString *WORK_COUNT;

@end

@interface ECWorksDetailModel : NSObject

@property (strong,nonatomic) NSString *Boo;

@property (strong,nonatomic) NSString *collect;

@property (strong,nonatomic) NSString *comment;

@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) NSString *cover;

@property (strong,nonatomic) NSString *createdate;

@property (strong,nonatomic) NSString *housetype;

@property (strong,nonatomic) NSString *workdID;

@property (strong,nonatomic) NSString *istop;

@property (strong,nonatomic) NSString *praise;

@property (strong,nonatomic) NSString *praiseType;

@property (strong,nonatomic) NSString *style;

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *type;

@property (strong,nonatomic) NSString *iscollect;

@property (strong,nonatomic) ECWorksDetailUserModel *user;

@property (strong,nonatomic) NSString *user_id;

@end

@interface ECWorksModel : NSObject

@property (strong,nonatomic) NSString *collect;

@property (strong,nonatomic) NSString *NAME;

@property (strong,nonatomic) NSString *RIGHTS;

@property (strong,nonatomic) NSString *TITLE_IMG;

@property (strong,nonatomic) NSString *cover;

@property (strong,nonatomic) NSString *worksID;

@property (strong,nonatomic) NSString *praise;

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *user_id;

@property (strong,nonatomic) NSString *collect_id;

@end
