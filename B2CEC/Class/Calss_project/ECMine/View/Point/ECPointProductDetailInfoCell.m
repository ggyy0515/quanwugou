//
//  ECPointProductDetailInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointProductDetailInfoCell.h"
#import "ECPointProductDetailInfoModel.h"

@interface ECPointProductDetailInfoCell ()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UILabel *stockLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation ECPointProductDetailInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_descLabel) {
        _descLabel = [UILabel new];
    }
    [self.contentView addSubview:_descLabel];
    _descLabel.font = FONT_36;
    _descLabel.textColor = DarkMoreColor;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.f);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(weakSelf.descLabel.font.lineHeight);
    }];
    
    if (!_pointLabel) {
        _pointLabel = [UILabel new];
    }
    [self.contentView addSubview:_pointLabel];
    
    if (!_stockLabel) {
        _stockLabel = [UILabel new];
    }
    [self.contentView addSubview:_stockLabel];
    _stockLabel.textAlignment = NSTextAlignmentRight;
    _stockLabel.font = FONT_24;
    _stockLabel.textColor = LightMoreColor;
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = BaseColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(1.f);
    }];
    
}

- (void)setModel:(ECPointProductDetailInfoModel *)model {
    _model = model;
    WEAK_SELF
    
    NSMutableAttributedString *point = [[NSMutableAttributedString alloc] initWithString:model.point
                                                                              attributes:@{NSFontAttributeName:FONT_32,
                                                                                           NSForegroundColorAttributeName:UIColorFromHexString(@"#ee383b")}];
    [point appendAttributedString:[[NSAttributedString alloc] initWithString:@" 积分"
                                                                  attributes:@{NSFontAttributeName:FONT_24,
                                                                               NSForegroundColorAttributeName:LightMoreColor}]];
    _pointLabel.attributedText = point;
    CGFloat width = ceilf([point boundingRectWithSize:CGSizeMake(1000, 16.f)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                              context:nil].size.width);
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(weakSelf.descLabel.mas_bottom).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(width, 16.f));
    }];
    
    _stockLabel.text = [NSString stringWithFormat:@"库存：%@", model.stock];
    [_stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(weakSelf.pointLabel.mas_bottom);
        make.height.mas_equalTo(weakSelf.stockLabel.font.lineHeight);
        make.left.mas_equalTo(weakSelf.pointLabel.mas_right);
    }];
    
    _descLabel.text = model.name;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
