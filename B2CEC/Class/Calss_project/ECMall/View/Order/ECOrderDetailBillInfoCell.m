//
//  ECOrderDetailBillInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailBillInfoCell.h"
#import "ECOrderListModel.h"

@interface ECOrderDetailBillInfoCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ECOrderDetailBillInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (_label) {
        _label = [UILabel new];
    }
    [self.contentView addSubview:_label];
    _label.textColor = LightMoreColor;
    _label.font = FONT_32;
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 12.f, 0, -12.f));
    }];
    
}

- (void)setModel:(ECOrderListModel *)model {
    _model = model;
    
    _label.text = [NSString stringWithFormat:@"发票抬头：%@", model.billTitle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
