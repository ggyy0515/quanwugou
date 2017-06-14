//
//  ECMallFilterView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallFilterView.h"

@interface ECMallFilterView ()

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIButton *timeBtn;

@property (nonatomic, strong) UIButton *salesBtn;

@property (nonatomic, strong) UIButton *priceBtn;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIImageView *filterImageView;

@property (nonatomic, strong) UIButton *filterBtn;

@end

@implementation ECMallFilterView

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = UIColorFromHexString(@"#FCFCFC");
    
    CGFloat btnOffset = [CMPublicMethod getWidthWithContent:@"默认" height:30.f font:15.f] + 8.f;
    
    if (!_topLine) {
        _topLine = [UIView new];
    }
    [self addSubview:_topLine];
    _topLine.backgroundColor = UIColorFromHexString(@"#E8E8E8");
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.left.right.mas_equalTo(weakSelf);
    }];
    
    if (!_filterImageView) {
        _filterImageView = [UIImageView new];
    }
    _filterImageView.image = [UIImage imageNamed:@"screen"];
    [self addSubview:_filterImageView];
    [_filterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-8.f);
    }];
    
    if (!_filterBtn) {
        _filterBtn = [UIButton new];
    }
    [self addSubview:_filterBtn];
    [_filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0.f);
        make.width.mas_equalTo(36.f);
    }];
    [_filterBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.filterBtnClick) {
            weakSelf.filterBtnClick();
        }
    }];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.filterImageView.mas_left).offset(-8.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(0.5, 25.f));
    }];
    
    if (!_timeBtn) {
        _timeBtn = [UIButton new];
    }
    [self addSubview:_timeBtn];
    _timeBtn.titleLabel.font = FONT_28;
    [_timeBtn setTitle:@"时间" forState:UIControlStateNormal];
    [_timeBtn setTitleColor:LightColor forState:UIControlStateNormal];
    [_timeBtn setTitleColor:DarkColor forState:UIControlStateSelected];
    [_timeBtn setImage:[UIImage imageNamed:@"Reverse_none"] forState:UIControlStateNormal];
    [_timeBtn setImage:[UIImage imageNamed:@"Reverse"] forState:UIControlStateSelected];
    _timeBtn.imageEdgeInsets = UIEdgeInsetsMake(0.f, btnOffset, 0.f, -btnOffset);
    [_timeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.sortType = ECSortType_time;
        if (weakSelf.sortTypeClickBlock) {
            weakSelf.sortTypeClickBlock(ECSortType_time);
        }
    }];
    
    if (!_salesBtn) {
        _salesBtn = [UIButton new];
    }
    [self addSubview:_salesBtn];
    _salesBtn.titleLabel.font = FONT_28;
    [_salesBtn setTitle:@"销量" forState:UIControlStateNormal];
    [_salesBtn setTitleColor:LightColor forState:UIControlStateNormal];
    [_salesBtn setTitleColor:DarkColor forState:UIControlStateSelected];
    [_salesBtn setImage:[UIImage imageNamed:@"Reverse_none"] forState:UIControlStateNormal];
    [_salesBtn setImage:[UIImage imageNamed:@"Reverse"] forState:UIControlStateSelected];
    _salesBtn.imageEdgeInsets = UIEdgeInsetsMake(0.f, btnOffset, 0.f, -btnOffset);
    [_salesBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.sortType = ECSortType_sales;
        if (weakSelf.sortTypeClickBlock) {
            weakSelf.sortTypeClickBlock(ECSortType_sales);
        }
    }];
    
    if (!_priceBtn) {
        _priceBtn = [UIButton new];
    }
    [self addSubview:_priceBtn];
    _priceBtn.titleLabel.font = FONT_28;
    [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    [_priceBtn setTitleColor:LightColor forState:UIControlStateNormal];
    [_priceBtn setTitleColor:DarkColor forState:UIControlStateSelected];
    [_priceBtn setImage:[UIImage imageNamed:@"order_none"] forState:UIControlStateNormal];
    _priceBtn.imageEdgeInsets = UIEdgeInsetsMake(0.f, btnOffset, 0.f, -btnOffset);
    [_priceBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.sortType = ECSortType_price;
        if (weakSelf.sortTypeClickBlock) {
            weakSelf.sortTypeClickBlock(ECSortType_price);
        }
    }];
    
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(8.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    
    [_salesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.timeBtn.mas_right).offset(8.f);
        make.centerY.height.width.mas_equalTo(weakSelf.timeBtn);
    }];
    
    [_priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.salesBtn.mas_right).offset(8.f);
        make.centerY.height.width.mas_equalTo(weakSelf.timeBtn);
        make.right.mas_equalTo(weakSelf.line.mas_right).offset(-8.f);
    }];
    
    
}

- (void)setSortType:(ECSortType)sortType {
    ECSortType preSortType = _sortType;
    _sortType = sortType;
    _timeBtn.selected = sortType == ECSortType_time;
    _salesBtn.selected = sortType == ECSortType_sales;
    _priceBtn.selected = sortType == ECSortType_price;
    [_priceBtn setImage:[UIImage imageNamed:@"order_none"] forState:UIControlStateNormal];
    if (sortType == ECSortType_price) {
        if (sortType == preSortType) {
            if (_sortDescType == ECSortDescType_asc) {
                self.sortDescType = ECSortDescType_desc;
            } else {
                self.sortDescType = ECSortDescType_asc;
            }
        } else {
            self.sortDescType = ECSortDescType_desc;
        }
    } else {
        self.sortDescType = ECSortDescType_desc;
    }
}

- (void)setSortDescType:(ECSortDescType)sortDescType {
    _sortDescType = sortDescType;
    if (_sortType == ECSortType_price) {
        if (sortDescType == ECSortDescType_desc) {
            [_priceBtn setImage:[UIImage imageNamed:@"order_Reverse"] forState:UIControlStateNormal];
        } else {
            [_priceBtn setImage:[UIImage imageNamed:@"order_rise"] forState:UIControlStateNormal];
        }
    }
}

- (void)setIsHideFilter:(BOOL)isHideFilter {
    WEAK_SELF
    _isHideFilter = isHideFilter;
    _filterBtn.hidden = isHideFilter;
    _filterImageView.hidden = isHideFilter;
    if (isHideFilter) {
        [_filterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0.f, 22.f));
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-8.f);
        }];
        
        [_filterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0.f, 22.f));
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-8.f);
        }];
    } else {
        [_filterImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-8.f);
        }];
        
        [_filterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0.f);
            make.width.mas_equalTo(36.f);
        }];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
