//
//  ECProductAppraiseImageCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductAppraiseImageCell.h"
#import "ECProductAppraiseImageModel.h"

@interface ECProductAppraiseImageCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ECProductAppraiseImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setModel:(ECProductAppraiseImageModel *)model {
    _model = model;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
