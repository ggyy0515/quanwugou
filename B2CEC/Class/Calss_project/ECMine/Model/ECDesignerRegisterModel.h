//
//  ECDesignerRegisterModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECDesignerRegisterModel : NSObject

@property (strong,nonatomic) NSString *userid;

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSString *sex;

@property (strong,nonatomic) NSString *birth;

@property (strong,nonatomic) NSString *province;

@property (strong,nonatomic) NSString *city;

@property (strong,nonatomic) NSString *nativeplace;

@property (strong,nonatomic) NSString *profession;

@property (strong,nonatomic) NSString *school;

@property (strong,nonatomic) NSString *obtainyears;

@property (strong,nonatomic) NSString *charge;

@property (strong,nonatomic) NSString *type;

@property (strong,nonatomic) NSString *phone;

@property (strong,nonatomic) NSString *email;

@property (strong,nonatomic) NSString *company;


@property (strong,nonatomic) NSString *headImgUrl;

@property (strong,nonatomic) NSString *resume;

@property (strong,nonatomic) NSString *experience;

@property (strong,nonatomic) NSString *certificateImgUrls;

//以下数据仅用来过度，不做任何储存
@property (strong,nonatomic) NSString *style;

@property (strong,nonatomic) UIImage *iconImage;

@property (strong,nonatomic) NSMutableArray *introduceArray;

@property (strong,nonatomic) NSMutableArray *introduceHeightArray;

@property (strong,nonatomic) NSMutableArray *introduceFlagArray;

@property (strong,nonatomic) NSMutableArray *certificateArray;

@property (strong,nonatomic) NSMutableArray *certificateHeightArray;

@property (strong,nonatomic) NSMutableArray *certificateFlagArray;

+ (ECDesignerRegisterModel *)getNullDesignerRegisterModel;

@end
