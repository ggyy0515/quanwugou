//
//  ECWalletPageBillHeader.m
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWalletPageBillHeader.h"

@implementation ECWalletPageBillHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        WEAK_SELF
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.font = FONT_28;
        titleLabel.textColor = DarkMoreColor;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 12.f, 0, -12.f));
        }];
        titleLabel.text = @"暂无账单数据";
        titleLabel.tag = 10001;
        
        UIView *line = [UIView new];
        [self addSubview:line];
        line.backgroundColor = BaseColor;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(weakSelf.contentMode);
            make.height.mas_equalTo(1.f);
        }];
    }
    return self;
}

- (void)setListCount:(NSInteger)listCount {
    _listCount = listCount;
    UILabel *titleLabel = (UILabel *)[self viewWithTag:10001];
    if (listCount == 0) {
        titleLabel.text = @"暂无账单数据";
        self.backgroundColor = BaseColor;
    } else {
        titleLabel.text = @"账单明细";
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
