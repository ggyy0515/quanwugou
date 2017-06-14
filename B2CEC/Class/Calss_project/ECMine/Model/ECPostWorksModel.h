//
//  ECPostWorksModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECPostWorksModel : NSObject

@property (strong,nonatomic) NSString *userid;

@property (strong,nonatomic) NSString *style;

@property (strong,nonatomic) NSString *type;

@property (strong,nonatomic) NSString *housetype;

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSString *cover;

@property (strong,nonatomic) NSString *content;

//
@property (strong,nonatomic) UIImage *coverImage;

@property (strong,nonatomic) NSMutableArray *contentArray;

@property (strong,nonatomic) NSMutableArray *contentHeightArray;

@property (strong,nonatomic) NSMutableArray *contentFlagArray;

@end
