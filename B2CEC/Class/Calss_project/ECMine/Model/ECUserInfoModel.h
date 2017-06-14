//
//  ECUserInfoModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/6.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECUserInfoUserModel : NSObject

@property (strong,nonatomic) NSString *NAME;

@property (strong,nonatomic) NSString *RIGHTS;

@property (strong,nonatomic) NSString *TITLE_IMG;

@property (strong,nonatomic) NSString *USERSTATE;

@property (strong,nonatomic) NSString *ATTENTION;

@end

@interface ECUserInfoDesignerModel : NSObject

@property (strong,nonatomic) NSString *birth;

@property (strong,nonatomic) NSString *charge;

@property (strong,nonatomic) NSString *city;

@property (strong,nonatomic) NSString *company;

@property (strong,nonatomic) NSString *designer_id;

@property (strong,nonatomic) NSString *email;

@property (strong,nonatomic) NSString *experience;

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSString *nativeplace;

@property (strong,nonatomic) NSString *obtainyears;

@property (strong,nonatomic) NSString *phone;

@property (strong,nonatomic) NSString *profession;

@property (strong,nonatomic) NSString *province;

@property (strong,nonatomic) NSString *resumeUrl;

@property (strong,nonatomic) NSString *school;

@property (strong,nonatomic) NSString *sex;

@property (strong,nonatomic) NSString *state;

@property (strong,nonatomic) NSString *userid;

@property (strong,nonatomic) NSString *desigerHeadImg;

@property (strong,nonatomic) NSString *style;

@end

@interface ECUserInfoModel : NSObject

@property (strong,nonatomic) NSString *ATTENTION_COUNT;

@property (strong,nonatomic) NSString *FANS_COUNT;

@property (strong,nonatomic) NSString *WORK_COUNT;

@property (strong,nonatomic) ECUserInfoDesignerModel *designerinfo;

@property (strong,nonatomic) ECUserInfoUserModel *user;

@end

@interface ECEditUserInfoModel : NSObject

@property (strong,nonatomic) NSString *USERSTATE;

@property (strong,nonatomic) NSString *NAME;

@property (strong,nonatomic) NSString *USER_ID;

@property (strong,nonatomic) NSString *RIGHTS;

@property (strong,nonatomic) NSString *USERINFO_ID;

@property (strong,nonatomic) NSString *SEX;

@property (strong,nonatomic) NSString *EMAIL;

@property (strong,nonatomic) NSString *BIRTH;

@property (strong,nonatomic) NSString *TITLE_IMG;

@property (strong,nonatomic) NSString *NATIVEPLACE;

@end
