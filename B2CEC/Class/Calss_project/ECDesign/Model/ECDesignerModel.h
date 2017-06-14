//
//  ECDesignerModel.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECDesignerOrderDetailModel : NSObject

@property (strong,nonatomic) NSString *batchNo;

@property (strong,nonatomic) NSString *claim;

@property (strong,nonatomic) NSString *createdate;

@property (strong,nonatomic) NSString *cycle;

@property (strong,nonatomic) NSString *decoratetype;

@property (strong,nonatomic) NSString *describe;

@property (strong,nonatomic) NSString *designer_id;

@property (strong,nonatomic) NSString *designer_user_id;

@property (strong,nonatomic) NSString *dname;

@property (strong,nonatomic) NSString *dtitle_img;

@property (strong,nonatomic) NSString *housearea;

@property (strong,nonatomic) NSString *housetype;

@property (strong,nonatomic) NSString *orderid;

@property (assign,nonatomic) CGFloat lat;

@property (assign,nonatomic) CGFloat lng;

@property (strong,nonatomic) NSString *location;

@property (strong,nonatomic) NSString *money;

@property (strong,nonatomic) NSString *paymode;

@property (strong,nonatomic) NSString *state;

@property (strong,nonatomic) NSString *style;

@property (strong,nonatomic) NSString *tranNo;

@property (strong,nonatomic) NSString *uname;

@property (strong,nonatomic) NSString *updatedate;

@property (strong,nonatomic) NSString *user_id;

@property (strong,nonatomic) NSString *utitle_img;

@property (strong,nonatomic) NSArray *imgurls;

@end

@interface ECDesignerModel : NSObject

@property (strong,nonatomic) NSString *ATTENTION;

@property (strong,nonatomic) NSString *ATTENTION_COUNT;

@property (strong,nonatomic) NSString *FANS_COUNT;

@property (strong,nonatomic) NSString *NAME;

@property (strong,nonatomic) NSString *TITLE_IMG;

@property (strong,nonatomic) NSString *USERINFO_ID;

@property (strong,nonatomic) NSString *USER_ID;

@property (strong,nonatomic) NSString *WORK_COUNT;

@property (strong,nonatomic) NSArray *coverList;

@end
