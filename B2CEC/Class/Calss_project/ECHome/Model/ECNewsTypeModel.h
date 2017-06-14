//
//  ECNewsTypeModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECNewsTypeModel : NSObject<NSCoding,NSCopying>

@property (strong,nonatomic) NSString *NAME;

@property (strong,nonatomic) NSString *BIANMA;

@property (strong,nonatomic) NSString *ICON;

@property (strong,nonatomic) NSString *ORDER_BY;


+ (void)saveNewsType:(NSArray *)array;

+ (NSMutableArray *)loadNewsType;
@end
