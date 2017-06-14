//
//  CMWorksTypeDataManager.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMWorksTypeDataManager.h"

@implementation CMWorksTypeModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"NAME":@"NAME",
             @"BIANMA":@"BIANMA"
             };
}

@end

@implementation CMWorksTypeListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"allcasestyle":@"allcasestyle",
             @"allcasetype":@"allcasetype",
             @"allhousetype":@"allhousetype"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"allcasestyle" : [CMWorksTypeModel class],
             @"allcasetype" : [CMWorksTypeModel class],
             @"allhousetype" : [CMWorksTypeModel class]
             };
}

@end

@implementation CMWorksTypeDataManager

singleton_implementation(CMWorksTypeDataManager)

- (void)loadPublicDataFromNetwork:(void(^)())completeBlock {
    WEAK_SELF
    [ECHTTPServer requestGetPostWorksTypesucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            weakSelf.model = [CMWorksTypeListModel yy_modelWithDictionary:result];
        }else{
            [weakSelf loadPublicDataFromNetwork:^{
                
            }];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf loadPublicDataFromNetwork:^{
            
        }];
    }];
}

@end
