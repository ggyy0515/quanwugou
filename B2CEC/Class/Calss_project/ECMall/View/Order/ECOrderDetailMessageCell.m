//
//  ECOrderDetailMessageCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailMessageCell.h"
#import "ECOrderListModel.h"

@interface ECOrderDetailMessageCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ECOrderDetailMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_label) {
        _label = [UILabel new];
    }
    [self.contentView addSubview:_label];
    _label.font = FONT_28;
    _label.textColor = LightColor;
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 12.f, 0, -12.f));
    }];
}

- (void)setModel:(ECOrderListModel *)model {
    _model = model;
    _label.text = model.message;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
