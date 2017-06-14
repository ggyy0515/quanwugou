//
//  ECPointProductDetailViewController.h
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@class ECPointProductListModel;

@interface ECPointProductDetailViewController : CMBaseViewController

- (instancetype)initWithModel:(ECPointProductListModel *)listModel;

@end
