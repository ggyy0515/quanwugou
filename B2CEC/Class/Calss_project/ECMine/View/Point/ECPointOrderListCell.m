//
//  ECPointOrderListCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointOrderListCell.h"
#import "ECPointOrderListModel.h"

@interface ECPointOrderListCell ()

@property (nonatomic, strong) UILabel *orderNumLabel;
@property (nonatomic, strong) UILabel *orderTimeLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *pointLabel;

@end

@implementation ECPointOrderListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_orderNumLabel) {
        _orderNumLabel = [UILabel new];
    }
    [self.contentView addSubview:_orderNumLabel];
    _orderNumLabel.font = FONT_28;
    _orderNumLabel.textColor = LightColor;
    
    if (!_orderTimeLabel) {
        _orderTimeLabel = [UILabel new];
    }
    [self.contentView addSubview:_orderTimeLabel];
    _orderTimeLabel.font = FONT_28;
    _orderTimeLabel.textColor = LightColor;
    _orderNumLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = BaseColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(36.f);
        make.height.mas_equalTo(1.f);
    }];
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.line.mas_bottom).offset(40.f);
        make.size.mas_equalTo(CGSizeMake(59.f, 59.f));
    }];
    [_imageView setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = DarkColor;
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.imageView.mas_top).offset(6.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
    }];
    
    if (!_pointLabel) {
        _pointLabel = [UILabel new];
    }
    [self.contentView addSubview:_pointLabel];
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.nameLabel);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(12.f);
        make.height.mas_equalTo(16.f);
    }];
}

- (void)setModel:(ECPointOrderListModel *)model {
    WEAK_SELF
    _model = model;
    
    _orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@", model.orderNo];
    CGFloat width = [CMPublicMethod getWidthWithLabel:_orderNumLabel];
    [_orderNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_top).offset(18.f);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.orderNumLabel.font.lineHeight));
    }];
    
    NSDateFormatter *dateFt = [[NSDateFormatter alloc] init];
    [dateFt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFt dateFromString:model.createDate];
    [dateFt setDateFormat:@"yyyy/MM/dd HH:mm"];
    _orderTimeLabel.text = [dateFt stringFromDate:date];
    [_orderTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.centerY.height.mas_equalTo(weakSelf.orderNumLabel);
        make.left.mas_equalTo(weakSelf.orderNumLabel.mas_right).offset(12.f);
    }];
    
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    
    _nameLabel.text = model.name;
    
    NSMutableAttributedString *point = [[NSMutableAttributedString alloc] initWithString:model.point
                                                                              attributes:@{NSFontAttributeName:FONT_32,
                                                                                           NSForegroundColorAttributeName:DarkMoreColor}];
    [point appendAttributedString:[[NSAttributedString alloc] initWithString:@"积分"
                                                                  attributes:@{NSFontAttributeName:FONT_24,
                                                                               NSForegroundColorAttributeName:LightColor}]];
    _pointLabel.attributedText = point;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
