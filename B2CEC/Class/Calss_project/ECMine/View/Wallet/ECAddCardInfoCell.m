
//
//  ECAddCardInfoCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAddCardInfoCell.h"

@interface ECAddCardInfoCell ()



@end

@implementation ECAddCardInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_32;
    _titleLabel.textColor = LightMoreColor;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo(70.f);
    }];
    
    if (!_textField) {
        _textField = [UITextField new];
    }
    [self.contentView addSubview:_textField];
    _textField.font = FONT_32;
    _textField.textColor = DarkMoreColor;
    _textField.borderStyle = UITextBorderStyleNone;
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel.mas_right).offset(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
    }];
    [_textField addTarget:self action:@selector(textFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    
    if (!_arrow) {
        _arrow = [UIImageView new];
    }
    [self.contentView addSubview:_arrow];
    [_arrow setImage:[UIImage imageNamed:@"enter"]];
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8.f, 15.f));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.right.mas_equalTo(-12.f);
    }];
    _arrow.hidden = YES;
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = UIColorFromHexString(@"#dddddd");
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(weakSelf.textField);
        make.height.mas_equalTo(1.f);
    }];
}

- (void)textFieldValueChanged {
    if (_contentChanged) {
        _contentChanged(self.indexPath, _textField.text);
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
