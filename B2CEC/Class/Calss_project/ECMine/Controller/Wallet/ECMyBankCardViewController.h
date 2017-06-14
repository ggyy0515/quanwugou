//
//  ECMyBankCardViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@class ECBankCardListModel;


/**
 页面类型

 - MyBankCardType_list: 纯展示，不可点击
 - MyBankCardType_select: 可以点击选择银行，选择后pop出
 */
typedef NS_ENUM(NSInteger, MyBankCardType) {
    MyBankCardType_list,
    MyBankCardType_select
};

@interface ECMyBankCardViewController : CMBaseViewController

- (instancetype)initWithMyBankCardType:(MyBankCardType)type;

@property (nonatomic, copy) void(^didSelectCard)(ECBankCardListModel *cardModel);


@end
