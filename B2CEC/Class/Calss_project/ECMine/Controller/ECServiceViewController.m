//
//  ECServiceViewController.m
//  B2CEC
//
//  Created by 曙华 on 16/7/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECServiceViewController.h"
#import "WJRegularVerify.h"

@interface ECServiceViewController ()

@property (nonatomic, strong) SHTextView *textView;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation ECServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clickPushBtn)];
    self.navigationItem.rightBarButtonItem.tintColor = MainColor;
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)creatUI{
    WEAK_SELF
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *ideaLabel = [UILabel new];
    ideaLabel.text = @"您的意见";
    ideaLabel.font = [UIFont systemFontOfSize:14.f];
    ideaLabel.textColor = DarkMoreColor;
    [self.view addSubview:ideaLabel];
    
    UILabel *contactLabel = [UILabel new];
    contactLabel.text = @"联系方式";
    contactLabel.font = [UIFont systemFontOfSize:14.f];
    contactLabel.textColor = DarkMoreColor;
    [self.view addSubview:contactLabel];
    
    _textView = [[SHTextView alloc] initWithFrame:CGRectZero textChangeBlock:^(UITextView *textView) {
        weakSelf.numberLabel.text = [NSString stringWithFormat:@"%ld/160",(long)textView.text.length];
        if (textView.text.length > 160) {
            textView.text = [textView.text substringToIndex:160];
        }
    }];
    _textView.placeholder = @"请输入您的宝贵问题与意见，我们将不断优化与服务";
    _textView.placeholderColor = LightPlaceholderColor;
    _textView.font = [UIFont systemFontOfSize:14.f];
    [topView addSubview:_textView];
    
    _numberLabel = [UILabel new];
    _numberLabel.font = [UIFont systemFontOfSize:12.f];
    _numberLabel.textColor = BaseColor;
    _numberLabel.text = @"0/160";
    [topView addSubview:_numberLabel];
    
    _textField = [UITextField new];
    _textField.font = [UIFont systemFontOfSize:14.f];
    _textField.keyboardType = UIKeyboardTypePhonePad;
    [_textField setValue:LightPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    _textField.placeholder = @"请输入您的手机号，方便后期与您联系";
    [bottomView addSubview:_textField];
    
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(42);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(193.f);
    }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topView.mas_right).offset(-8);
        make.bottom.mas_equalTo(topView.mas_bottom).offset(-10);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_top).offset(10);
        make.right.mas_equalTo(topView.mas_right).offset(-8);
        make.left.mas_equalTo(topView.mas_left).offset(8);
        make.bottom.mas_equalTo(weakSelf.numberLabel.mas_top).offset(-10);
    }];
    
    [ideaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(topView.mas_top).offset(-10);
        make.left.mas_equalTo(8);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(42);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(40);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView.mas_left).offset(8);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
    }];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomView.mas_top).offset(-10);
        make.left.mas_equalTo(8);
    }];
    
}


- (void)clickPushBtn{
    if (_textView.text.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请输入您的宝贵意见哦"];
        return;
    }
    if (_textField.text.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请输入您的联系电话"];
        return;
    }
    if (![WJRegularVerify phoneNumberVerify:_textField.text]) {
        [SVProgressHUD showInfoWithStatus:@"您输入的手机号不正确哦"];
        return;
    }
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestPostFeebackWithContent:_textView.text WithPhone:_textField.text succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            [SVProgressHUD showSuccessWithStatus:result[@"msg"]];
            [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
        } else {
            EC_SHOW_REQUEST_ERROR_INFO
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
