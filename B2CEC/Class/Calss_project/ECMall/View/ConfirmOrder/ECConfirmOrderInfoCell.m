//
//  ECConfirmOrderInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/1.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECConfirmOrderInfoCell.h"
#import "ECConfirmOrderInfoModel.h"

@interface ECConfirmOrderInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ECConfirmOrderInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_28;
    _titleLabel.textColor = LightMoreColor;
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    [self.contentView addSubview:_contentLabel];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = DarkMoreColor;
    _contentLabel.font = FONT_28;
}

- (void)setModel:(ECConfirmOrderInfoModel *)model {
    _model = model;
    [self setTitle:model.title content:model.content];
}

- (void)setTitle:(NSString *)title content:(NSString *)content {
    WEAK_SELF
    _titleLabel.text = title;
    CGFloat width = [CMPublicMethod getWidthWithLabel:_titleLabel];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.width.mas_equalTo(width);
    }];
    
    _contentLabel.text = content;
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel.mas_right).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
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
