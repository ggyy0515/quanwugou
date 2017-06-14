//
//  SHImageListViewCollectionViewCell.m
//  ZhongShanEC
//
//  Created by Tristan on 16/6/6.
//  Copyright © 2016年 com.shuhuasoft.www. All rights reserved.
//

#import "SHImageListViewCollectionViewCell.h"

@implementation SHImageListViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    WEAK_SELF
    if (self = [super initWithFrame:frame]) {
        if (!_imageView) {
            _imageView = [UIImageView new];
        }
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
            make.edges.mas_equalTo(weakSelf.contentView).insets(padding);
        }];
    }
    return self;
}

@end
