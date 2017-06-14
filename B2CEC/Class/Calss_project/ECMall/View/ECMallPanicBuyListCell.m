//
//  ECMallPanicBuyListCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallPanicBuyListCell.h"
#import "ECMallPanicBuyListModel.h"

@interface ECMallPanicBuyListCell ()

/**
 商品图片
 */
@property (nonatomic, strong) UIImageView *imageView;
/**
 剩余时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *timeBgView;
/**
 商品名
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 价格
 */
@property (nonatomic, strong) UILabel *priceLabel;
/**
 原价
 */
@property (nonatomic, strong) UILabel *originPriceLabel;

@end

@implementation ECMallPanicBuyListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        
        [self defaultConfig];
    }
    return self;
}

- (void)dealloc {
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_PURCHASE_COUNTDOWN, nil);
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView setImage:[UIImage imageNamed:@"placeholder_goods2"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo((SCREENWIDTH - 24.f) / 2.f);
    }];
    
    CGFloat timeWidth = ceilf([@"88天 55:55:55" boundingRectWithSize:CGSizeMake(10000, 12.f)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:FONT_24}
                                                            context:nil].size.width) + 10.f;
    
    if (!_timeBgView) {
        _timeBgView = [UIView new];
    }
    [self.contentView addSubview:_timeBgView];
    _timeBgView.backgroundColor = UIColorFromHexString(@"#626262");
    _timeBgView.alpha = 0.8;
    [_timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf.imageView);
        make.size.mas_equalTo(CGSizeMake(timeWidth, 30.f));
    }];
    
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
    }
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = FONT_24;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.timeBgView);
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_28;
    _nameLabel.textColor = LightMoreColor;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(14.f);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).offset(8.f);
    }];
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self.contentView addSubview:_priceLabel];
    _priceLabel.font = FONT_B_28;
    _priceLabel.textColor = UIColorFromHexString(@"#EB3A41");
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(8.f);
        make.height.mas_equalTo(14.f);
    }];
    
    if (!_originPriceLabel) {
        _originPriceLabel = [UILabel new];
    }
    [self.contentView addSubview:_originPriceLabel];
    _originPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(11.f);
        make.top.mas_equalTo(weakSelf.priceLabel.mas_bottom).offset(4.f);
    }];
}

- (void)defaultConfig {
    ADD_OBSERVER_NOTIFICATION(self, @selector(loadModelTime), NOTIFICATION_NAME_PURCHASE_COUNTDOWN, nil);
}

- (void)setModel:(ECMallPanicBuyListModel *)model {
    _model = model;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
    _nameLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    NSAttributedString *originPrice = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model.originPrice]
                                                                      attributes:@{NSFontAttributeName:FONT_22,
                                                                                   NSForegroundColorAttributeName:LightColor,
                                                                                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid)
                                                                                   }];
    _originPriceLabel.attributedText = originPrice;
    [self loadModelTime];
    
}

- (void)loadModelTime {
    _timeLabel.text = [_model currentTimeString];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
