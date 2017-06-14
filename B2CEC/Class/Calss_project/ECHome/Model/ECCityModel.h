//
//  ECCityModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECCityModel : NSObject

@property (strong,nonatomic) NSString *NAME;

@property (strong,nonatomic) NSString *BIANMA;

@property (strong,nonatomic) NSArray<ECCityModel *> *subDict;

@end
