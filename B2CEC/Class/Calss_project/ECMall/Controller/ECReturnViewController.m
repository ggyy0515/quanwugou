//
//  ECReturnViewController.m
//  B2CEC
//
//  Created by 曙华 on 16/7/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECReturnViewController.h"

@interface ECReturnViewController ()

@property (nonatomic, strong) SHTextView *textView;


@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, copy) NSString *titleStr;

@end

@implementation ECReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clickPushReturnBtn)];
    self.navigationItem.rightBarButtonItem.tintColor = MainColor;
    [self creatUI];

    // Do any additional setup after loading the view.
}


- (void)creatUI{
    if (_selectType == ECReturnViewControllerReturn) {
        _titleStr = @"退货";
    }else{
        _titleStr = @"换货";
    }
    SELF_BASENAVI.titleLabel.text = [NSString stringWithFormat:@"%@申请",_titleStr];
    WEAK_SELF
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    
    UILabel *ideaLabel = [UILabel new];
    ideaLabel.text = [NSString stringWithFormat:@"%@原因",_titleStr];
    ideaLabel.font = [UIFont systemFontOfSize:14.f];
    ideaLabel.textColor = LightMoreColor;
    [self.view addSubview:ideaLabel];
    
    
    _textView = [[SHTextView alloc] initWithFrame:CGRectZero textChangeBlock:^(UITextView *textView) {
        weakSelf.numberLabel.text = [NSString stringWithFormat:@"%ld/300",(long)textView.text.length];
        if (textView.text.length > 300) {
            textView.text = [textView.text substringToIndex:300];
        }
    }];
    _textView.placeholder = [NSString stringWithFormat:@"请输入您要%@的原因，以便商家方便与您沟通",_titleStr];
    _textView.placeholderColor = LightColor;
    _textView.font = [UIFont systemFontOfSize:14.f];
    [topView addSubview:_textView];
    
    _numberLabel = [UILabel new];
    _numberLabel.font = [UIFont systemFontOfSize:12.f];
    _numberLabel.textColor = LightMoreColor;
    _numberLabel.text = @"0/300";
    [topView addSubview:_numberLabel];
    
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(42);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(260.f);
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
    
    
}



- (void)clickPushReturnBtn{
    WEAK_SELF
    if (_textView.text.length < 1 ||[CMPublicMethod isEmpty:_textView.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入您的宝贵意见哦"];
        return;
    }
    
    if (_selectType == ECReturnViewControllerReturn)
    {//退货
        SHOWSVP
        [ECHTTPServer requestReturnGoodWithUserId:[Keychain objectForKey:EC_USER_ID]
                                          orderId:_orderId
                                           reason:_textView.text
                                          succeed:^(NSURLSessionDataTask *task, id result) {
                                              if (IS_REQUEST_SUCCEED(result)) {
                                                  POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_ORDER_DETAIL_DATA, nil);
                                                  POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA, nil);
                                                  RequestSuccess(result)
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  EC_SHOW_REQUEST_ERROR_INFO
                                              }
                                          }
                                           failed:^(NSURLSessionDataTask *task, NSError *error) {
                                              RequestFailure
                                           }];
    }
    else
    {//换货
       
        
    }

    
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
