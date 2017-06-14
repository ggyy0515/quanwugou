//
//  ECDesignerOrderModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECDesignerOrderModel : NSObject

@property (strong,nonatomic) NSString *batchNo;
//具体要求
@property (strong,nonatomic) NSString *claim;
//下单时间
@property (strong,nonatomic) NSString *createdate;
//设计订单的周期
@property (strong,nonatomic) NSString *cycle;
//装修户型
@property (strong,nonatomic) NSString *decoratetype;
//描述
@property (strong,nonatomic) NSString *describe;
//设计师的ID
@property (strong,nonatomic) NSString *designer_id;
//#设计师的姓名
@property (strong,nonatomic) NSString *dname;
//设计师头像图片路径
@property (strong,nonatomic) NSString *dtitle_img;
//房屋面积
@property (strong,nonatomic) NSString *housearea;
//房屋类型
@property (strong,nonatomic) NSString *housetype;
//下单ID
@property (strong,nonatomic) NSString *orderID;

@property (strong,nonatomic) NSArray<NSString *> *imgurls;
//纬度
@property (assign,nonatomic) CGFloat lat;
//经度
@property (assign,nonatomic) CGFloat lng;
//具体位置
@property (strong,nonatomic) NSString *location;
//金额
@property (strong,nonatomic) NSString *money;

@property (strong,nonatomic) NSString *paymode;
//订单状态
@property (strong,nonatomic) NSString *state;
//期望风格
@property (strong,nonatomic) NSString *style;

@property (strong,nonatomic) NSString *tranNo;
//下单用户的昵称
@property (strong,nonatomic) NSString *uname;
//下单用户的ID
@property (strong,nonatomic) NSString *user_id;
//下单用户的头像,
@property (strong,nonatomic) NSString *utitle_img;
//修改时间,
@property (strong,nonatomic) NSString *updatedate;

@end
