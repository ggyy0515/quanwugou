//
//  ECPlaceOrderModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECPlaceOrderModel : NSObject
@property (strong,nonatomic) NSString *orderID;
//设计师用户ID
@property (strong,nonatomic) NSString *designer_id;
//用户ID
@property (strong,nonatomic) NSString *user_id;
//简单描述
@property (strong,nonatomic) NSString *describe;
//房屋面积
@property (strong,nonatomic) NSString *housearea;
//具体位置
@property (strong,nonatomic) NSString *location;
//经度
@property (assign,nonatomic) CGFloat lng;
//纬度
@property (assign,nonatomic) CGFloat lat;
//房屋类型（传编码值）
@property (strong,nonatomic) NSString *housetype;
@property (strong,nonatomic) NSString *housename;
//装修户型（传编码值）
@property (strong,nonatomic) NSString *decoratetype;
@property (strong,nonatomic) NSString *decoratename;
//期望风格（传编码值）
@property (strong,nonatomic) NSString *style;
@property (strong,nonatomic) NSString *stylename;
//具体要求
@property (strong,nonatomic) NSString *claim;
//具体要求中上传的图片(json数组格式)
@property (strong,nonatomic) NSArray<NSString *> *imgurls;
//完成周期/时间
@property (strong,nonatomic) NSString *cycle;

@end
