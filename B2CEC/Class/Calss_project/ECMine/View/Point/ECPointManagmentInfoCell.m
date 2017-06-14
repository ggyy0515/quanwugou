//
//  ECPointManagmentInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointManagmentInfoCell.h"
#import "ECPointInfoModel.h"

@interface ECPointManagmentInfoCell ()

@property (nonatomic, strong) UILabel *totalPointTitleLabel;
@property (nonatomic, strong) UILabel *totalPointLabel;
@property (nonatomic, strong) UILabel *usefulPointTitleLabel;
@property (nonatomic, strong) UILabel *usefulPointLabel;
@property (nonatomic, strong) UILabel *usefulMoneyLabel;
@property (nonatomic, strong) UILabel *frozenPointTitleLabel;
@property (nonatomic, strong) UILabel *frozenPointLabel;
@property (nonatomic, strong) UILabel *frozenMoneyLabel;

@end

@implementation ECPointManagmentInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_totalPointTitleLabel) {
        _totalPointTitleLabel = [UILabel new];
    }
    [self.contentView addSubview:_totalPointTitleLabel];
    _totalPointTitleLabel.textColor = LightColor;
    _totalPointTitleLabel.font = FONT_32;
    _totalPointTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!_totalPointLabel) {
        _totalPointLabel = [UILabel new];
    }
    [self.contentView addSubview:_totalPointLabel];
    _totalPointLabel.font = [UIFont systemFontOfSize:52.f];
    _totalPointLabel.textColor = DarkMoreColor;
    _totalPointLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!_usefulPointTitleLabel) {
        _usefulPointTitleLabel = [UILabel new];
    }
    [self.contentView addSubview:_usefulPointTitleLabel];
    _usefulPointTitleLabel.textColor = LightColor;
    _usefulPointTitleLabel.font = FONT_24;
    _usefulPointTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!_usefulPointLabel) {
        _usefulPointLabel = [UILabel new];
    }
    [self.contentView addSubview:_usefulPointLabel];
    _usefulPointLabel.font = [UIFont systemFontOfSize:21.f];
    _usefulPointLabel.textColor = UIColorFromHexString(@"#5DC17C");
    _usefulPointLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!_usefulMoneyLabel) {
        _usefulMoneyLabel = [UILabel new];
    }
    [self.contentView addSubview:_usefulMoneyLabel];
    _usefulMoneyLabel.font = FONT_28;
    _usefulMoneyLabel.textColor = DarkMoreColor;
    _usefulMoneyLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!_frozenPointTitleLabel) {
        _frozenPointTitleLabel = [UILabel new];
    }
    [self.contentView addSubview:_frozenPointTitleLabel];
    _frozenPointTitleLabel.font = FONT_24;
    _frozenPointTitleLabel.textColor = LightColor;
    _frozenPointTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!_frozenPointLabel) {
        _frozenPointLabel = [UILabel new];
    }
    [self.contentView addSubview:_frozenPointLabel];
    _frozenPointLabel.font = [UIFont systemFontOfSize:21.f];
    _frozenPointLabel.textColor = UIColorFromHexString(@"#ef5959");
    _frozenPointLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!_frozenMoneyLabel) {
        _frozenMoneyLabel = [UILabel new];
    }
    [self.contentView addSubview:_frozenMoneyLabel];
    _frozenMoneyLabel.textColor = LightMoreColor;
    _frozenMoneyLabel.font = FONT_28;
    _frozenMoneyLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setModel:(ECPointInfoModel *)model {
    WEAK_SELF
    _model = model;
    
    _totalPointTitleLabel.text = @"总积分";
    CGFloat width = [CMPublicMethod getWidthWithLabel:_totalPointTitleLabel];
    [_totalPointTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.f);
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.totalPointTitleLabel.font.lineHeight));
    }];
    
    _totalPointLabel.text = model.totalPoint;
    [_totalPointLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.totalPointTitleLabel.mas_bottom).offset(16.f);
        make.height.mas_equalTo(weakSelf.totalPointLabel.font.lineHeight);
    }];
    
    _usefulPointTitleLabel.text = @"可用积分";
    [_usefulPointTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left);
        make.right.mas_equalTo(weakSelf.contentView.mas_left).offset(SCREENWIDTH / 2.f);
        make.top.mas_equalTo(weakSelf.totalPointLabel.mas_bottom).offset(28.f);
        make.height.mas_equalTo(weakSelf.usefulPointTitleLabel.font.lineHeight);
    }];
    
    _usefulPointLabel.text = model.point;
    [_usefulPointLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.usefulPointTitleLabel);
        make.top.mas_equalTo(weakSelf.usefulPointTitleLabel.mas_bottom).offset(12.f);
        make.height.mas_equalTo(weakSelf.usefulPointLabel.font.lineHeight);
    }];
    
    if ([[USERDEFAULT objectForKey:EC_USER_STATUS] isEqualToString:@"2"]) {
        NSString *usefulMoney = [NSString stringWithFormat:@"(￥%.0lf)", floor(model.point.floatValue / model.rate.floatValue)];
        _usefulMoneyLabel.text = usefulMoney;
    }
    [_usefulMoneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.usefulPointLabel.mas_bottom).offset(4.f);
        make.left.right.mas_equalTo(weakSelf.usefulPointTitleLabel);
        make.height.mas_equalTo(weakSelf.usefulMoneyLabel.font.lineHeight);
    }];
    
    _frozenPointTitleLabel.text = @"冻结积分";
    [_frozenPointTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.left.mas_equalTo(weakSelf.usefulPointTitleLabel.mas_right);
        make.top.mas_equalTo(weakSelf.usefulPointTitleLabel.mas_top);
        make.height.mas_equalTo(weakSelf.frozenPointTitleLabel.font.lineHeight);
    }];
    
    _frozenPointLabel.text = model.frozenPoint;
    [_frozenPointLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.frozenPointTitleLabel);
        make.top.mas_equalTo(weakSelf.usefulPointLabel.mas_top);
        make.height.mas_equalTo(weakSelf.frozenPointLabel.font.lineHeight);
    }];
    
    if ([[USERDEFAULT objectForKey:EC_USER_STATUS] isEqualToString:@"2"]) {
        NSString *frozenMoney = [NSString stringWithFormat:@"(￥%.0lf)", floor(model.frozenPoint.floatValue / model.rate.floatValue)];
        _frozenMoneyLabel.text = frozenMoney;
    }
    [_frozenMoneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.frozenPointTitleLabel);
        make.top.mas_equalTo(weakSelf.usefulMoneyLabel.mas_top);
        make.height.mas_equalTo(weakSelf.frozenMoneyLabel.font.lineHeight);
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
