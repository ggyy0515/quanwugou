//
//  ECMineModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMineUserModel : NSObject
//用户昵称,
@property (copy,nonatomic) NSString *NAME;
//0-普通用户1-VIP用户2-设计师
@property (copy,nonatomic) NSString *RIGHTS;
//3-未申请0-审核中1-审核通过2-审核未通过
@property (copy,nonatomic) NSString *USERSTATE;
//用户头像
@property (copy,nonatomic) NSString *TITLE_IMG;

@end

@interface ECMineModel : NSObject
//关注数量,
@property (copy,nonatomic) NSString *ATTENTION_COUNT;
//粉丝数量
@property (copy,nonatomic) NSString *FANS_COUNT;
//#积分
@property (copy,nonatomic) NSString *INTEGRATE;
//钱包金额
@property (copy,nonatomic) NSString *MONEY;
//退换货数量
@property (copy,nonatomic) NSString *RETURNOREXCHANGE;
//待评价数量
@property (copy,nonatomic) NSString *WAITCOMMENT;
//待收货数量
@property (copy,nonatomic) NSString *WAITGETGOODS;
//待付款数量
@property (copy,nonatomic) NSString *WAITPAY;
//待发货数量
@property (copy,nonatomic) NSString *WAITSENDGOODS;
//作品数量
@property (copy,nonatomic) NSString *WORK_COUNT;
//0-未有记录1-存在未读记录,
@property (copy,nonatomic) NSString *ISEXISTUNREAD;
//是否存在需要处理的设计订单
@property (copy,nonatomic) NSString *ISEXISTUNDEAL;

@property (strong,nonatomic) ECMineUserModel *user;

@end
