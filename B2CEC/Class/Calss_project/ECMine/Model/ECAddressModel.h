//
//  ECAddressModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECAddressModel : NSObject

@property (strong,nonatomic) NSString *address;

@property (strong,nonatomic) NSString *area;

@property (strong,nonatomic) NSString *userid;

@property (strong,nonatomic) NSString *consignee;

@property (strong,nonatomic) NSString *is_default;

@property (strong,nonatomic) NSString *mobile_no;

@property (strong,nonatomic) NSString *delivery_id;

@end
