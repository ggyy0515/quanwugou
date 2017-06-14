//
//  ECNewsBigImageBottomView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECNewsBigImageBottomView : UIView

@property (strong,nonatomic) NSString *commentCount;

@property (copy,nonatomic) void (^inputClickBlock)();

@property (copy,nonatomic) void (^commentClickBlock)();

@property (copy,nonatomic) void (^collecClickBlock)();

@property (copy,nonatomic) void (^shareClickBlock)();

@end
