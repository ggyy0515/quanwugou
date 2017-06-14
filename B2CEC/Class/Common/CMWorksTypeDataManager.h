//
//  CMWorksTypeDataManager.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMWorksTypeModel : NSObject

@property (strong,nonatomic) NSString *NAME;

@property (strong,nonatomic) NSString *BIANMA;

@end

@interface CMWorksTypeListModel : NSObject

@property (strong,nonatomic) NSArray<CMWorksTypeModel *> *allcasestyle;

@property (strong,nonatomic) NSArray<CMWorksTypeModel *> *allcasetype;

@property (strong,nonatomic) NSArray<CMWorksTypeModel *> *allhousetype;

@end

@interface CMWorksTypeDataManager : NSObject

singleton_interface(CMWorksTypeDataManager)

@property (strong,nonatomic) CMWorksTypeListModel *model;

- (void)loadPublicDataFromNetwork:(void(^)())completeBlock;

@end
