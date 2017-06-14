//
//  ECPointOrderListModel.m
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointOrderListModel.h"
#import "ECPointOrderDetailInfoModel.h"

@implementation ECPointOrderListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"orderIds":@"integral_id",
             @"orderNo":@"orderno",
             @"tradeNo":@"tranno",
             @"name":@"proname",
             @"point":@"total_amount",
             @"createDate":@"createdate",
             @"image":@"imagetitle"
             };
}

- (instancetype)initWithECPointOrderDetailInfoModel:(ECPointOrderDetailInfoModel *)model {
    if (self = [super init]) {
        _orderIds = model.orderId;
        _orderNo = model.orderNo;
        _tradeNo = model.tradeNo;
        _name = model.proName;
        _point = model.point;
        _createDate = model.createDate;
        _image = model.image;
    }
    return self;
}

@end
