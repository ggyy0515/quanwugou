//
//  ECLoginViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECLoginViewController.h"
#import "ECLoginTableViewCell.h"
#import "ECRegisterViewController.h"
#import "ECBindMobileViewController.h"
#import "ECForgetPasswordViewController.h"

@interface ECLoginViewController ()

@property (strong,nonatomic) UIButton *closeBtn;

@property (strong,nonatomic) UIView *navBarHairlineImageView;

@property (strong,nonatomic) UMSocialUserInfoResponse *userinfo;

@end

@implementation ECLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _navBarHairlineImageView = [CMPublicMethod findNavBottomLineView:self.navigationController.navigationBar];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    if (SYS_VERSION < 7.f) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }else{
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    _navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _navBarHairlineImageView.hidden = NO;
}

- (void)createUI{
    WEAK_SELF
    
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 22.f, 22.f)];
    }
    [_closeBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [_closeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [WEAKSELF_BASENAVI dismissViewControllerAnimated:YES completion:nil];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_closeBtn];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestLoginWithMobile:(NSString *)mobile WithPassword:(NSString *)password{
    WEAK_SELF
    [self.tableView endEditing:YES];
    
    SHOWSVP
    
    [ECHTTPServer requestLoginWithUserName:mobile password:password succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            [APP_DELEGATE loginSucceedActionWithRequestResult:result];
            [WEAKSELF_BASENAVI dismissViewControllerAnimated:YES completion:nil];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestQQLogin{
    WEAK_SELF
    SHOWSVP
    [ECHTTPServer requestQQLoginWithUid:self.userinfo.uid WithIconurl:self.userinfo.iconurl WithName:self.userinfo.name succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            RequestSuccess(result);
            [APP_DELEGATE loginSucceedActionWithRequestResult:result];
            [WEAKSELF_BASENAVI dismissViewControllerAnimated:YES completion:nil];
        }else if (([[result objectForKey:@"code"] integerValue] == 88888)){
            DISMISSSVP
            ECBindMobileViewController *bindMobileVC = [[ECBindMobileViewController alloc] init];
            bindMobileVC.userinfo = weakSelf.userinfo;
            bindMobileVC.type = UMSocialPlatformType_QQ;
            [WEAKSELF_BASENAVI pushViewController:bindMobileVC animated:YES titleLabel:@"绑定手机号"];
        }else{
            DISMISSSVP
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestWeixinLogin{
    WEAK_SELF
    SHOWSVP
    [ECHTTPServer requestWeixinLoginWithUid:self.userinfo.uid WithIconurl:self.userinfo.iconurl WithName:self.userinfo.name succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            [APP_DELEGATE loginSucceedActionWithRequestResult:result];
            [WEAKSELF_BASENAVI dismissViewControllerAnimated:YES completion:nil];
        }else if (([[result objectForKey:@"code"] integerValue] == 88888)){
            DISMISSSVP
            ECBindMobileViewController *bindMobileVC = [[ECBindMobileViewController alloc] init];
            bindMobileVC.userinfo = weakSelf.userinfo;
            bindMobileVC.type = UMSocialPlatformType_WechatSession;
            [WEAKSELF_BASENAVI pushViewController:bindMobileVC animated:YES titleLabel:@"绑定手机号"];
        }else{
            DISMISSSVP
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)gotoPlatform:(UMSocialPlatformType)type completion:(void(^)())completion{
    WEAK_SELF
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:self completion:^(id result, NSError *error) {
        if (!error) {
            weakSelf.userinfo = (UMSocialUserInfoResponse *)result;
            completion();
        }
    }];
}

- (void)gotoWeixinLogin{
    WEAK_SELF
    [self gotoPlatform:UMSocialPlatformType_WechatSession completion:^ {
        [weakSelf requestWeixinLogin];
    }];
}

- (void)gotoQQLogin{
    WEAK_SELF
    [self gotoPlatform:UMSocialPlatformType_QQ completion:^{
        [weakSelf requestQQLogin];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    
    ECLoginTableViewCell *cell = [ECLoginTableViewCell cellWithTableView:tableView];
    [cell setLoginBlock:^(NSString *mobile, NSString *password) {
        [weakSelf requestLoginWithMobile:mobile WithPassword:password];
    }];
    [cell setWeixinLoginBlock:^{
        [weakSelf gotoWeixinLogin];
    }];
    [cell setQqLoginBlock:^{
        [weakSelf gotoQQLogin];
    }];
    [cell setRegisterBlock:^{
        ECRegisterViewController *registerVC = [[ECRegisterViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:registerVC animated:YES titleLabel:@""];
    }];
    [cell setForgetPasswordBlock:^{
        ECForgetPasswordViewController *forgetPasswordVC = [[ECForgetPasswordViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:forgetPasswordVC animated:YES titleLabel:@"忘记密码"];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
