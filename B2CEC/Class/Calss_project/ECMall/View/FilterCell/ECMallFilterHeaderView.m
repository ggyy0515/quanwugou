//
//  ECMallFilterHeaderView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallFilterHeaderView.h"

@interface ECMallFilterHeaderView ()

@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation ECMallFilterHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self CreateBasicUI];
    }
    return self;
}


- (void)CreateBasicUI{
    self.backgroundColor = [UIColor whiteColor];
    
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
    }
    _nameLabel.textColor = LightMoreColor;
    _nameLabel.font = [UIFont systemFontOfSize:16.f];
    
    [self addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(13.f);
        make.bottom.mas_equalTo(-13.f);
    }];
    
}

- (void)setName:(NSString *)name{
    _name = name;
    _nameLabel.text = name;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
