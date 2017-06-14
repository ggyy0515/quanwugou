//
//  CMDropDatePikeViewController.h
//  TrCommerce
//
//  Created by Tristan on 15/11/23.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "CMBaseViewController.h"

@interface CMDropDatePikeViewController : CMBaseViewController

@property (nonatomic, strong) UIDatePicker *datePicker;
//@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) void(^hasSelectDate)(NSDate *date);

@end
