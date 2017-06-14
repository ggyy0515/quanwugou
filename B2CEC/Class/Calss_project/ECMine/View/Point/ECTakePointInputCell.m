//
//  ECTakePointInputCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTakePointInputCell.h"
#import "ECPointInfoModel.h"

@interface ECTakePointInputCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation ECTakePointInputCell

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
    _titleLabel.font = FONT_28;
    _titleLabel.textColor = LightMoreColor;
    _titleLabel.text = @"兑现积分";
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo(70.f);
    }];
    
    if (!_textField) {
        _textField = [UITextField new];
    }
    [self.contentView addSubview:_textField];
    _textField.font = FONT_28;
    _textField.textColor = DarkMoreColor;
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    [_textField setValue:UIColorFromHexString(@"#cccccc") forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    [_textField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    _textField.borderStyle = UITextBorderStyleNone;
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf.contentView);
        make.right.mas_equalTo(weakSelf.contentView).offset(-12.f);
        make.left.mas_equalTo(weakSelf.titleLabel.mas_right).offset(12.f);
    }];
}

- (void)setModel:(ECPointInfoModel *)model {
    _model = model;
    _textField.placeholder = [NSString stringWithFormat:@"最高%@",STR_EXISTS(model.point)];
}

- (void)textFieldChanged {
    if (_pointChange) {
        _pointChange(_textField.text);
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
