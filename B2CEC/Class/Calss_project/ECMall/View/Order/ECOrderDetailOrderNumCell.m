//
//  ECOrderDetailOrderNumCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/13.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailOrderNumCell.h"
#import "ECOrderListModel.h"

@interface ECOrderDetailOrderNumCell ()

@property (nonatomic, strong) UILabel *orderNumLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ECOrderDetailOrderNumCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_orderNumLabel) {
        _orderNumLabel = [UILabel new];
    }
    [self.contentView addSubview:_orderNumLabel];
    _orderNumLabel.textColor = LightMoreColor;
    _orderNumLabel.font = FONT_28;
    
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
    }
    [self.contentView addSubview:_timeLabel];
    _timeLabel.textColor = LightMoreColor;
    _timeLabel.font = FONT_28;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
}

- (void)setModel:(ECOrderListModel *)model {
    _model = model;
    WEAK_SELF
    
    _orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@", model.orderNo];
    CGFloat width = [CMPublicMethod getWidthWithLabel:_orderNumLabel];
    [_orderNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.orderNumLabel.font.lineHeight));
    }];
    
    NSDateFormatter *dateFt = [[NSDateFormatter alloc] init];
    [dateFt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFt dateFromString:model.createTime];
    [dateFt setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *time = [dateFt stringFromDate:date];
    _timeLabel.text = time;
    [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.mas_equalTo(weakSelf.orderNumLabel);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.left.mas_equalTo(weakSelf.orderNumLabel.mas_right);
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
