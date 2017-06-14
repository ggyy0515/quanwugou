//
//  ECProductPanicBuyInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/25.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductPanicBuyInfoCell.h"
#import "ECProductInfoModel.h"

@interface ECProductPanicBuyInfoCell ()

@property (nonatomic, strong) UIView *topLeftView;
@property (nonatomic, strong) UIView *topRightView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *originPriceLabel;
@property (nonatomic, strong) UILabel *stockLabel;
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *vipLogo;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UILabel *produceTimeLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation ECProductPanicBuyInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)dealloc {
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_PURCHASE_COUNTDOWN_IN_DETAIL, nil);
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_topLeftView) {
        _topLeftView = [UIView new];
    }
    [self.contentView addSubview:_topLeftView];
    _topLeftView.backgroundColor = UIColorFromHexString(@"#EB3A41");
    [_topLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake((SCREENWIDTH * (500.f / 750.f)), 60.f));
    }];
    
    if (!_topRightView) {
        _topRightView = [UIView new];
    }
    [self.contentView addSubview:_topRightView];
    _topRightView.backgroundColor = UIColorFromHexString(@"#E2E2E2");
    [_topRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(weakSelf.contentView);
        make.bottom.mas_equalTo(weakSelf.topLeftView);
        make.left.mas_equalTo(weakSelf.topLeftView.mas_right);
    }];
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self.topLeftView addSubview:_priceLabel];
    _priceLabel.font = [UIFont systemFontOfSize:26.f];
    _priceLabel.textColor = UIColorFromHexString(@"#ffffff");
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.topLeftView.mas_left).offset(20.f);
        make.top.mas_equalTo(weakSelf.topLeftView.mas_top).offset(8.f);
        make.right.mas_equalTo(weakSelf.topLeftView.mas_right);
        make.height.mas_equalTo(weakSelf.priceLabel.font.lineHeight);
    }];
    
    if (!_originPriceLabel) {
        _originPriceLabel = [UILabel new];
    }
    [self.topLeftView addSubview:_originPriceLabel];
    
    if (!_stockLabel) {
        _stockLabel = [UILabel new];
    }
    [_topLeftView addSubview:_stockLabel];
    _stockLabel.font = FONT_24;
    _stockLabel.textColor = UIColorFromHexString(@"#ffffff");
    _stockLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_timeTitleLabel) {
        _timeTitleLabel = [UILabel new];
    }
    [self.topRightView addSubview:_timeTitleLabel];
    _timeTitleLabel.font = FONT_24;
    _timeTitleLabel.textColor = LightMoreColor;
    _timeTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
    }
    [self.topRightView addSubview:_timeLabel];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = UIColorFromHexString(@"#222222");
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topLeftView.mas_bottom).offset(14.f);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
    }];
    
    if (!_vipLogo) {
        _vipLogo = [UIImageView new];
    }
    [self.contentView addSubview:_vipLogo];
    [_vipLogo setImage:[UIImage imageNamed:@"VIP"]];
    _vipLogo.hidden = YES;
    
    if (!_pointLabel) {
        _pointLabel = [UILabel new];
    }
    [self.contentView addSubview:_pointLabel];
    _pointLabel.font = FONT_26;
    _pointLabel.textColor = LightMoreColor;
    
    if (!_areaLabel) {
        _areaLabel = [UILabel new];
    }
    [self.contentView addSubview:_areaLabel];
    _areaLabel.font = FONT_26;
    _areaLabel.textColor = LightMoreColor;
    _areaLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_produceTimeLabel) {
        _produceTimeLabel = [UILabel new];
    }
    [self.contentView addSubview:_produceTimeLabel];
    _produceTimeLabel.font = FONT_26;
    _produceTimeLabel.textColor = LightMoreColor;
    _produceTimeLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = BaseColor;
}

- (void)setModel:(ECProductInfoModel *)model {
    WEAK_SELF
    _model = model;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.actPrice];
    
    NSMutableAttributedString *originPrice = [[NSMutableAttributedString alloc] initWithString:@"原价："
                                                                                    attributes:@{NSFontAttributeName:FONT_28,
                                                                                                 NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff")}];
    [originPrice appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model.price]
                                                                        attributes:@{NSFontAttributeName:FONT_28,
                                                                                     NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff"),
                                                                                     NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid)}]];
    _originPriceLabel.attributedText = originPrice;
    CGFloat width = ceil([originPrice boundingRectWithSize:CGSizeMake(10000, 14.f)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil].size.width);
    [_originPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.topLeftView.mas_left).offset(20.f);
        make.top.mas_equalTo(weakSelf.priceLabel.mas_bottom).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(width, 14.f));
    }];
    
    _stockLabel.text = [NSString stringWithFormat:@"剩余件数 %@", model.stock];
    width = [CMPublicMethod getWidthWithLabel:_stockLabel];
    [_stockLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.topLeftView.mas_right).offset(-20.f);
        make.bottom.mas_equalTo(weakSelf.originPriceLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.stockLabel.font.lineHeight));
    }];
    
    _timeTitleLabel.text = @"剩余时间";
    [_timeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.topRightView);
        make.top.mas_equalTo(weakSelf.topRightView.mas_top).offset(11.f);
        make.height.mas_equalTo(12.f);
    }];
    
    NSMutableAttributedString *leftTime = [[NSMutableAttributedString alloc] initWithString:[model getDay]
                                                                                 attributes:@{NSFontAttributeName:FONT_22,
                                                                                              NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff"),
                                                                                              NSBackgroundColorAttributeName:UIColorFromHexString(@"000000")}];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:[model getHour]
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff"),
                                                                                  NSBackgroundColorAttributeName:UIColorFromHexString(@"000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:@":"
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:[model getMinute]
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff"),
                                                                                  NSBackgroundColorAttributeName:UIColorFromHexString(@"000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:@":"
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:[model getSecond]
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff"),
                                                                                  NSBackgroundColorAttributeName:UIColorFromHexString(@"000000")}]];
    _timeLabel.attributedText = leftTime;
    [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.topRightView);
        make.height.mas_equalTo(11.f);
        make.top.mas_equalTo(weakSelf.timeTitleLabel.mas_bottom).offset(10.f);
    }];
    
    _nameLabel.text = model.name;
    
    CGFloat vipWidth = 0;
    CGFloat pointOffset = 0;
    if (model.isDiscount.integerValue == 0) {
        vipWidth = 22.f;
        pointOffset = 5.f;
        _vipLogo.hidden = NO;
    } else {
        vipWidth = 0;
        pointOffset = 0;
        _vipLogo.hidden = YES;
    }
    [_vipLogo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(vipWidth, 14.f));
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(18.f);
    }];
    
    _pointLabel.text = [NSString stringWithFormat:@"积分%@", model.point];
    width = [CMPublicMethod getWidthWithLabel:_pointLabel];
    [_pointLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.vipLogo.mas_right).offset(pointOffset);
        make.centerY.mas_equalTo(weakSelf.vipLogo.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.pointLabel.font.lineHeight));
    }];
    
    _areaLabel.text = [NSString stringWithFormat:@"产地：%@", model.area];
    width = [CMPublicMethod getWidthWithLabel:_areaLabel];
    [_areaLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20.f);
        make.centerY.mas_equalTo(weakSelf.pointLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.areaLabel.font.lineHeight));
    }];
    
    _produceTimeLabel.text = [NSString stringWithFormat:@"生产周期：%@天", model.period];
    [_produceTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.areaLabel.mas_left).offset(-16.f);
        make.left.mas_equalTo(weakSelf.pointLabel.mas_right).offset(16.f);
        make.centerY.mas_equalTo(weakSelf.pointLabel.mas_centerY);
        make.height.mas_equalTo(weakSelf.produceTimeLabel.font.lineHeight);
    }];
    
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH - 40.f, 1.f));
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
    
    [self defaultConfig];
    
}

- (void)loadModelTime {
    NSMutableAttributedString *leftTime = [[NSMutableAttributedString alloc] initWithString:[_model getDay]
                                                                                 attributes:@{NSFontAttributeName:FONT_22,
                                                                                              NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff"),
                                                                                              NSBackgroundColorAttributeName:UIColorFromHexString(@"000000")}];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:[_model getHour]
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff"),
                                                                                  NSBackgroundColorAttributeName:UIColorFromHexString(@"000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:@":"
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:[_model getMinute]
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff"),
                                                                                  NSBackgroundColorAttributeName:UIColorFromHexString(@"000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:@":"
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#000000")}]];
    [leftTime appendAttributedString:[[NSAttributedString alloc] initWithString:[_model getSecond]
                                                                     attributes:@{NSFontAttributeName:FONT_22,
                                                                                  NSForegroundColorAttributeName:UIColorFromHexString(@"#ffffff"),
                                                                                  NSBackgroundColorAttributeName:UIColorFromHexString(@"000000")}]];
    _timeLabel.attributedText = leftTime;
}

- (void)defaultConfig {
    ADD_OBSERVER_NOTIFICATION(self, @selector(loadModelTime), NOTIFICATION_NAME_PURCHASE_COUNTDOWN_IN_DETAIL, nil);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
