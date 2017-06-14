//
//  ECCartBottomView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCartBottomView.h"

@interface ECCartBottomView ()

//普通状态
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *orderBtn;

//编辑状态
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation ECCartBottomView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_allBtn) {
        _allBtn = [UIButton new];
    }
    [self addSubview:_allBtn];
    [_allBtn setTitle:@"  全选" forState:UIControlStateNormal];
    [_allBtn setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
    [_allBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_allBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    _allBtn.titleLabel.font = FONT_28;
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(8.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60.f, 40.f));
    }];
    [_allBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.allBtn.selected = !weakSelf.allBtn.selected;
        if (weakSelf.clickAllBtn) {
            weakSelf.clickAllBtn(weakSelf.allBtn.selected);
        }
    }];
    
    if (!_orderBtn) {
        _orderBtn = [UIButton new];
    }
    [self addSubview:_orderBtn];
    _orderBtn.backgroundColor = UIColorFromHexString(@"#1A191E");
    [_orderBtn setTitleColor:UIColorFromHexString(@"#ffffff") forState:UIControlStateNormal];
    [_orderBtn setTitle:@"去结算" forState:UIControlStateNormal];
    _orderBtn.titleLabel.font = FONT_32;
    [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH * (272.f / 750.f));
    }];
    [_orderBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickOrderBtn) {
            weakSelf.clickOrderBtn();
        }
    }];
    
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self addSubview:_priceLabel];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf.allBtn.mas_right);
        make.right.mas_equalTo(weakSelf.orderBtn.mas_left).offset(-12.f);
    }];
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
    }
    [self addSubview:_deleteBtn];
    _deleteBtn.backgroundColor = UIColorFromHexString(@"#EB3A41");
    [_deleteBtn setTitleColor:UIColorFromHexString(@"#ffffff") forState:UIControlStateNormal];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = FONT_32;
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH * (288.f / 750.f));
    }];
    _deleteBtn.hidden = YES;
    [_deleteBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickDeleteBtn) {
            weakSelf.clickDeleteBtn();
        }
    }];
    
    if (!_collectBtn) {
        _collectBtn = [UIButton new];
    }
    [self addSubview:_collectBtn];
    _collectBtn.backgroundColor = UIColorFromHexString(@"#1A191E");
    [_collectBtn setTitleColor:UIColorFromHexString(@"#ffffff") forState:UIControlStateNormal];
    [_collectBtn setTitle:@"转到收藏" forState:UIControlStateNormal];
    _collectBtn.titleLabel.font = FONT_32;
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf);
        make.right.mas_equalTo(weakSelf.deleteBtn.mas_left);
        make.width.mas_equalTo(weakSelf.deleteBtn.mas_width);
    }];
    _collectBtn.hidden = YES;
    [_collectBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickCollectBtn) {
            weakSelf.clickCollectBtn();
        }
    }];
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    if (isEdit) {
        _deleteBtn.hidden = NO;
        _collectBtn.hidden = NO;
        _priceLabel.hidden = YES;
    } else {
        _deleteBtn.hidden = YES;
        _collectBtn.hidden = YES;
        _priceLabel.hidden = NO;
    }
}

- (void)setPrice:(CGFloat)price {
    _price = price;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"总计:"
                                                                            attributes:@{NSFontAttributeName:FONT_32,
                                                                                         NSForegroundColorAttributeName:DarkMoreColor}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.0lf", price]
                                                                attributes:@{NSForegroundColorAttributeName:UIColorFromHexString(@"ee383b"),
                                                                             NSFontAttributeName:FONT_B_36}]];
    _priceLabel.attributedText = str;
}

@end
