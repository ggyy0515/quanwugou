//
//  ECMallTagViewCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallTagViewCell.h"
#import "ECMallTagModel.h"

@interface ECMallTagViewCell ()

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 选中时候的底部线条
 */
@property (nonatomic, strong) UILabel *line;

@end

@implementation ECMallTagViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:17.f];
    _titleLabel.textColor = LightMoreColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    
    if (!_line) {
        _line = [UILabel new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = MainColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(32.f);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
    }];
    _line.hidden = YES;
}

- (void)setModel:(ECMallTagModel *)model {
    WEAK_SELF
    _model = model;
    _titleLabel.text = model.name;
    if (model.isSel) {
        _titleLabel.textColor = MainColor;
        _line.hidden = NO;
    } else {
        _titleLabel.textColor = LightMoreColor;
        _line.hidden = YES;
    }
    CGFloat width = [model.name boundingRectWithSize:CGSizeMake(10000, 17.f)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]}
                                              context:nil].size.width;
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(width);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
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
