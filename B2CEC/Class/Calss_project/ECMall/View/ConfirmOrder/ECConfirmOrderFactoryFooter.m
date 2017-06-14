//
//  ECConfirmOrderFactoryFooter.m
//  B2CEC
//
//  Created by Tristan on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECConfirmOrderFactoryFooter.h"
#import "ECCartFactoryModel.h"

@interface ECConfirmOrderFactoryFooter ()
<
    UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *tf;

@end

@implementation ECConfirmOrderFactoryFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_tf) {
        _tf = [UITextField new];
    }
    [self.contentView addSubview:_tf];
    _tf.textColor = DarkColor;
    [_tf setBorderStyle:UITextBorderStyleNone];
    [_tf setValue:UIColorFromHexString(@"#cccccc") forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _tf.placeholder = @"给卖家留言";
    _tf.font = FONT_32;
    _tf.leftViewMode = UITextFieldViewModeAlways;
    _tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12.f, 10.f)];
    [_tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _tf.delegate = self;
    _tf.returnKeyType = UIReturnKeyDone;
}

- (void)setModel:(ECCartFactoryModel *)model {
    _model = model;
    if (model.message.length > 0) {
        _tf.text = model.message;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _model.message = textField.text;
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _model.message = textField.text;
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
}


@end
