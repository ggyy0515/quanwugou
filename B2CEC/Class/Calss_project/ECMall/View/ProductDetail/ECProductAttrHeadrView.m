//
//  ECProductAttrHeadrView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAttrHeadrView.h"

@implementation ECProductAttrHeadrView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.font = FONT_32;
    titleLabel.textColor = LightMoreColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"规格参数";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end
