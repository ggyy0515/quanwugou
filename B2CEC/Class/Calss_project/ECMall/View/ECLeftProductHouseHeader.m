//
//  ECLeftProductHouseHeader.m
//  B2CEC
//
//  Created by Tristan on 2016/12/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECLeftProductHouseHeader.h"

@implementation ECLeftProductHouseHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        WEAK_SELF
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"工厂尾货"]];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        imageView.userInteractionEnabled = YES;
        [imageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            if (weakSelf.tapAction) {
                weakSelf.tapAction();
            }
        }];
    }
    return self;
}


@end
