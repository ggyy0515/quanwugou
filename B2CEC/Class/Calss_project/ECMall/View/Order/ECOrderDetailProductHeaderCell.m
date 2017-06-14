//
//  ECOrderDetailProductHeaderCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailProductHeaderCell.h"
#import "ECOrderListModel.h"
#import "ECOrderProductModel.h"

@interface ECOrderDetailProductHeaderCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ECOrderDetailProductHeaderCell

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
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 12.f, 0.f, -12.f));
    }];
}

- (void)setModel:(ECOrderListModel *)model {
    _model = model;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"共"
                                                                            attributes:@{NSFontAttributeName:FONT_28,
                                                                                         NSForegroundColorAttributeName:LightColor}];
    __block NSInteger count = 0;
    [model.productList enumerateObjectsUsingBlock:^(ECOrderProductModel * _Nonnull productModel, NSUInteger idx, BOOL * _Nonnull stop) {
        count += productModel.count.integerValue;
    }];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", count]
                                                                attributes:@{NSFontAttributeName:FONT_28,
                                                                             NSForegroundColorAttributeName:DarkMoreColor}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"件商品"
                                                                attributes:@{NSFontAttributeName:FONT_28,
                                                                             NSForegroundColorAttributeName:LightColor}]];
    _contentLabel.attributedText = str;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
