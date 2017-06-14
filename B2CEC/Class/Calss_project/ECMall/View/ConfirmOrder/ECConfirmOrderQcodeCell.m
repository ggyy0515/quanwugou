//
//  ECConfirmOrderQcodeCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/1.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECConfirmOrderQcodeCell.h"

@interface ECConfirmOrderQcodeCell ()
<
    UITextFieldDelegate
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UISwitch *swh;
@property (nonatomic, strong) UITextField *infoTF;
@property (nonatomic, strong) UIButton *imageBtn;

@end

@implementation ECConfirmOrderQcodeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_swh) {
        _swh = [UISwitch new];
    }
    [self.contentView addSubview:_swh];
    _swh.tintColor = BaseColor;
    _swh.onTintColor = DarkMoreColor;
    _swh.on = NO;
    [_swh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.f, 30.f));
        make.top.mas_equalTo(weakSelf.mas_top).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
    }];
    _swh.on = NO;
    [_swh addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_32;
    _titleLabel.textColor = DarkMoreColor;
    _titleLabel.text = @"是否使用Q码";
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.swh.mas_centerY);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.right.mas_equalTo(weakSelf.swh.mas_left).offset(-12.f);
        make.height.mas_equalTo(weakSelf.titleLabel.font.lineHeight);
    }];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = UIColorFromHexString(@"#dddddd");
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(weakSelf.swh.mas_bottom).offset(12.f);
    }];
    
    if (!_infoTF) {
        _infoTF = [UITextField new];
    }
    [self.contentView addSubview:_infoTF];
    _infoTF.textColor = DarkColor;
    [_infoTF setBorderStyle:UITextBorderStyleNone];
    [_infoTF setValue:UIColorFromHexString(@"#cccccc") forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _infoTF.placeholder = @"填写Q码";
    _infoTF.hidden = YES;
    _infoTF.delegate = self;
    _infoTF.returnKeyType = UIReturnKeyDone;
    [_infoTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f - 22.f - 10.f);
        make.top.mas_equalTo(weakSelf.line.mas_bottom).offset(12.f);
        make.height.mas_equalTo(30.f);
    }];
    
    
    if (!_imageBtn) {
        _imageBtn = [UIButton new];
    }
    [self.contentView addSubview:_imageBtn];
    [_imageBtn setImage:[UIImage imageNamed:@"icon_right"] forState:UIControlStateNormal];
    _imageBtn.userInteractionEnabled = NO;
    _imageBtn.hidden = YES;
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.centerY.mas_equalTo(weakSelf.infoTF.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
    }];

}

- (void)switchValueChanged:(UISwitch *)sender {
    _infoTF.hidden = !sender.isOn;
    if (!sender.isOn) {
        _infoTF.text = nil;
    }
    if (_useQCodel) {
        _useQCodel(sender.isOn);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    [self checkQcodeIsValid:textField.text];
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
}

- (void)checkQcodeIsValid:(NSString *)qcode {
    _qCode = qcode;
    [SVProgressHUD show];
    [ECHTTPServer requestCheckQCode:qcode
                            succeed:^(NSURLSessionDataTask *task, id result) {
                                if (IS_REQUEST_SUCCEED(result)) {
                                    DISMISSSVP
                                    //Q码验证通过
                                    _imageBtn.hidden = NO;
                                    if (_didLoadQcodeValidState) {
                                        _didLoadQcodeValidState(qcode, YES);
                                    }
                                } else {
                                    EC_SHOW_REQUEST_ERROR_INFO
                                    _imageBtn.hidden = YES;
                                    if (_didLoadQcodeValidState) {
                                        _didLoadQcodeValidState(nil, NO);
                                    }
                                }
                            }
                             failed:^(NSURLSessionDataTask *task, NSError *error) {
                                 _imageBtn.hidden = YES;
                                 if (_didLoadQcodeValidState) {
                                     _didLoadQcodeValidState(nil, NO);
                                 }
                                 RequestFailure;
                             }];
}

- (void)setQCode:(NSString *)qCode {
    _qCode = qCode;
    if (qCode && qCode.length > 0) {
        _imageBtn.hidden = NO;
    } else {
        _imageBtn.hidden = YES;
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
