//
//  ECUserInfoModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/6.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoModel.h"

@implementation ECUserInfoUserModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"NAME":@"NAME",
             @"RIGHTS":@"RIGHTS",
             @"USERSTATE":@"USERSTATE",
             @"TITLE_IMG":@"TITLE_IMG",
             @"ATTENTION":@"ATTENTION"
             };
}

@end

@implementation ECUserInfoDesignerModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"birth":@"birth",
             @"charge":@"charge",
             @"city":@"city",
             @"company":@"company",
             @"designer_id":@"designer_id",
             @"email":@"email",
             @"experience":@"experience",
             @"name":@"name",
             @"nativeplace":@"nativeplace",
             @"obtainyears":@"obtainyears",
             @"phone":@"phone",
             @"profession":@"profession",
             @"province":@"province",
             @"resumeUrl":@"resumeUrl",
             @"school":@"school",
             @"sex":@"sex",
             @"state":@"state",
             @"userid":@"userid",
             @"desigerHeadImg":@"desigerHeadImg",
             @"style":@"style"
             };
}

@end

@implementation ECUserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"ATTENTION_COUNT":@"ATTENTION_COUNT",
             @"FANS_COUNT":@"FANS_COUNT",
             @"WORK_COUNT":@"WORK_COUNT",
             @"designerinfo":@"designerinfo",
             @"user":@"user"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"designerinfo" : [ECUserInfoDesignerModel class],
             @"user" : [ECUserInfoUserModel class]
             };
}

@end

@implementation ECEditUserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"USERSTATE":@"USERSTATE",
             @"NAME":@"NAME",
             @"USER_ID":@"USER_ID",
             @"RIGHTS":@"RIGHTS",
             @"USERINFO_ID":@"USERINFO_ID",
             @"SEX":@"SEX",
             @"EMAIL":@"EMAIL",
             @"BIRTH":@"BIRTH",
             @"TITLE_IMG":@"TITLE_IMG",
             @"NATIVEPLACE":@"NATIVEPLACE"
             };
}

@end
