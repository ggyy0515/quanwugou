//
//  ECMallHouseSubCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallHouseSubCell.h"
#import "ECMallHouseModel.h"

@interface ECMallHouseSubCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ECMallHouseSubCell

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
    [_imageView setImage:[UIImage imageNamed:@"placeholder_house"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setModel:(ECMallHouseModel *)model {
    _model = model;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_house"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
