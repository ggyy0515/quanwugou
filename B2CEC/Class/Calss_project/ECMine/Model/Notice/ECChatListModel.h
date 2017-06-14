//
//  ECChatListModel.h
//  B2CEC
//
//  Created by Tristan on 2016/12/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMConversation;

@interface ECChatListModel : NSObject

@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, copy) NSString *firendIds;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *name;

@end
