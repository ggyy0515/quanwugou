//
//  ECCartSectionHeader.m
//  B2CEC
//
//  Created by Tristan on 2016/11/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCartSectionHeader.h"
#import "ECCartFactoryModel.h"

@interface ECCartSectionHeader ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation ECCartSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_topView) {
        _topView = [UIView new];
    }
    [self addSubview:_topView];
    _topView.backgroundColor = BaseColor;
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(4.f);
    }];
    
    if (!_bottomLine) {
        _bottomLine = [UIView new];
    }
    [self addSubview:_bottomLine];
    _bottomLine.backgroundColor = UIColorFromHexString(@"#DDDDDD");
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(0.5f);
    }];
    
    if (!_topLine) {
        _topLine = [UIView new];
    }
    [self addSubview:_topLine];
    _topLine.backgroundColor = UIColorFromHexString(@"#DDDDDD");
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self addSubview:_nameLabel];
    _nameLabel.font = FONT_28;
    _nameLabel.textColor = LightMoreColor;
    
    if (!_countLabel) {
        _countLabel = [UILabel new];
    }
    [self addSubview:_countLabel];
    _countLabel.textAlignment = NSTextAlignmentRight;
    
}

- (void)setModel:(ECCartFactoryModel *)model {
    WEAK_SELF
    _model = model;
    
    _nameLabel.text = model.seller;
    CGFloat width = [CMPublicMethod getWidthWithLabel:_nameLabel];
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(4.f);
        make.left.mas_equalTo(weakSelf.mas_left).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(width, weakSelf.nameLabel.font.lineHeight));
    }];
    
    NSMutableAttributedString *count = [[NSMutableAttributedString alloc] initWithString:@"共"
                                                                              attributes:@{NSFontAttributeName:FONT_28,
                                                                                           NSForegroundColorAttributeName:LightColor}];
    [count appendAttributedString:[[NSAttributedString alloc] initWithString:model.productCount
                                                                  attributes:@{NSFontAttributeName:FONT_28,
                                                                               NSForegroundColorAttributeName:LightMoreColor}]];
    [count appendAttributedString:[[NSAttributedString alloc] initWithString:@"件"
                                                                  attributes:@{NSFontAttributeName:FONT_28,
                                                                               NSForegroundColorAttributeName:LightColor}]];
    _countLabel.attributedText = count;
    [_countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_right).offset(10);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-12.f);
        make.height.mas_equalTo(14.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(4.f);
    }];
    NSLog(@"");
}


@end
