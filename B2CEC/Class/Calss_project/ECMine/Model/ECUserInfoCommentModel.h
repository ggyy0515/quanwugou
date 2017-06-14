//
//  ECUserInfoCommentModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/19.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECUserInfoCommentModel : NSObject

@property (strong,nonatomic) NSString *comment;

@property (strong,nonatomic) NSString *comment_id;

@property (strong,nonatomic) NSString *createdate;

@property (strong,nonatomic) NSString *designer_id;

@property (strong,nonatomic) NSArray *imgurls;

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSString *star_level;

@property (strong,nonatomic) NSString *title_img;

@property (strong,nonatomic) NSString *userid;

@end
