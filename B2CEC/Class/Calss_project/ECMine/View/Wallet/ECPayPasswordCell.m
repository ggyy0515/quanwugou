//
//  ECPayPasswordCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPayPasswordCell.h"

@interface ECPayPasswordCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ECPayPasswordCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font = [UIFont boldSystemFontOfSize:60.f];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.textColor = MainColor;
    _contentLabel.text = @"·";
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _contentLabel.hidden = YES;
}

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    _contentLabel.hidden = !isShow;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
