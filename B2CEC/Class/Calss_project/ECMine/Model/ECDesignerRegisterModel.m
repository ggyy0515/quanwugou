//
//  ECDesignerRegisterModel.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerRegisterModel.h"

@implementation ECDesignerRegisterModel

+ (ECDesignerRegisterModel *)getNullDesignerRegisterModel{
    ECDesignerRegisterModel *model = [[ECDesignerRegisterModel alloc] init];
    model.userid = [Keychain objectForKey:EC_USER_ID];
    model.name = @"";
    model.sex = @"";
    model.birth = @"";
    model.province = @"";
    model.city = @"";
    model.nativeplace = @"";
    model.profession = @"";
    model.school = @"";
    model.obtainyears = @"";
    model.charge = @"";
    model.type = @"";
    model.phone = @"";
    model.email = @"";
    model.company = @"";
    
    model.style = @"";
    model.headImgUrl = @"";
    model.resume = @"";
    model.experience = @"";
    model.certificateImgUrls = @"";
    return model;
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"userid":@"userid",
             @"name":@"name",
             @"sex":@"sex",
             @"birth":@"birth",
             @"province":@"province",
             @"city":@"city",
             @"nativeplace":@"nativeplace",
             @"profession":@"profession",
             @"school":@"school",
             @"obtainyears":@"obtainyears",
             @"charge":@"charge",
             @"type":@"type",
             @"phone":@"phone",
             @"email":@"email",
             @"company":@"company",
             @"headImgUrl":@"headImgUrl",
             @"resume":@"resume",
             @"experience":@"experience",
             @"certificateImgUrls" : @"certificateImgUrls"
             };
}

@end
