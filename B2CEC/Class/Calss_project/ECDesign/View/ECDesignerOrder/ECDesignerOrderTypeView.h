//
//  ECDesignerOrderTypeView.h
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECDesignerOrderTypeView : UIView

@property (strong,nonatomic) NSArray *dataArray;

@property (assign,nonatomic) NSInteger currentIndex;

@property (copy,nonatomic) void (^didSelectIndex)(NSInteger);

@end
