//
//  ECPointOrderDetailExpressHeader.m
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointOrderDetailExpressHeader.h"
#import "ECPointOrderDetailInfoModel.h"

@interface ECPointOrderDetailExpressHeader ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *comLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation ECPointOrderDetailExpressHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self addSubview:_imageView];
    [_imageView setImage:[UIImage imageNamed:@"iconfont-icon-yxj-express"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22.f, 14.f));
    }];
    _imageView.hidden = YES;
    
    if (!_comLabel) {
        _comLabel = [UILabel new];
    }
    [self addSubview:_comLabel];
    _comLabel.font = FONT_32;
    _comLabel.textColor = DarkColor;
    [_comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.top.mas_equalTo(weakSelf.mas_top).offset(10.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(weakSelf.comLabel.font.lineHeight);
    }];
    
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
    }
    [self addSubview:_numberLabel];
    _numberLabel.font = FONT_24;
    _numberLabel.textColor = LightColor;
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.comLabel);
        make.height.mas_equalTo(weakSelf.numberLabel.font.lineHeight);
        make.top.mas_equalTo(weakSelf.comLabel.mas_bottom).offset(8.f);
    }];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self addSubview:_line];
    _line.backgroundColor = BaseColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(1.f);
    }];
    _line.hidden = YES;
}

- (void)setModel:(ECPointOrderDetailInfoModel *)model {
    _model = model;
    
    if (model.state.integerValue == 1 && model.expressNumber && ![model.expressNumber isEqualToString:@""]) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView.hidden = _numberLabel.hidden = _line.hidden = NO;
        _comLabel.text = model.express;
        _numberLabel.text = [NSString stringWithFormat:@"物流单号：%@", model.expressNumber];
    } else {
        self.backgroundColor = BaseColor;
        _imageView.hidden = _numberLabel.hidden = _line.hidden = YES;
        _comLabel.text = @"暂无物流信息";
    }
}

@end
