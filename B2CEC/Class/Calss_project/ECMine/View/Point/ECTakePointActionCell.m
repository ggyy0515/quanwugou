//
//  ECTakePointActionCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTakePointActionCell.h"
#import "ECPointInfoModel.h"

@interface ECTakePointActionCell ()

@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation ECTakePointActionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = BaseColor;
    
    if (!_allBtn) {
        _allBtn = [UIButton new];
    }
    [self.contentView addSubview:_allBtn];
    _allBtn.titleLabel.numberOfLines = 0;
    _allBtn.backgroundColor = [UIColor whiteColor];
    _allBtn.layer.borderColor = UIColorFromHexString(@"#dddddd").CGColor;
    _allBtn.layer.borderWidth = 0.5;
    _allBtn.layer.cornerRadius = 4.f;
    _allBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo((SCREENWIDTH - 36.f) / 2.f);
    }];
    [_allBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickAllBtn) {
            weakSelf.clickAllBtn();
        }
    }];
    
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
    }
    [self.contentView addSubview:_confirmBtn];
    [_confirmBtn setBackgroundColor:MainColor];
    [_confirmBtn setTitle:@"立即兑现" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:UIColorFromHexString(@"#ffffff") forState:UIControlStateNormal];
    _confirmBtn.layer.cornerRadius = 4.f;
    _confirmBtn.titleLabel.font = FONT_32;
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.mas_equalTo(weakSelf.allBtn);
        make.right.mas_equalTo(-12.f);
        make.left.mas_equalTo(weakSelf.allBtn.mas_right).offset(12.f);
    }];
    [_confirmBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickConfirmBtn) {
            weakSelf.clickConfirmBtn();
        }
    }];
}

- (void)setModel:(ECPointInfoModel *)model {
    _model = model;
    NSMutableAttributedString *allTitle = [[NSMutableAttributedString alloc] initWithString:@"全部兑现"
                                                                                 attributes:@{NSFontAttributeName:FONT_32,
                                                                                              NSForegroundColorAttributeName:DarkMoreColor}];
    [allTitle appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n(可用积分￥%@)", STR_EXISTS(model.point)]
                                                                     attributes:@{NSFontAttributeName:FONT_24,
                                                                                  NSForegroundColorAttributeName:LightColor}]];
    [_allBtn setAttributedTitle:allTitle forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
