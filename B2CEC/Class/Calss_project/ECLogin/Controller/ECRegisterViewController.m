//
//  ECRegisterViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECRegisterViewController.h"
#import "ECRegisterTableViewCell.h"
#import "ECAdvertisingViewController.h"

@interface ECRegisterViewController ()

@property (strong,nonatomic) UIButton *closeBtn;

@property (strong,nonatomic) UIView *navBarHairlineImageView;

@end

@implementation ECRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _navBarHairlineImageView = [CMPublicMethod findNavBottomLineView:self.navigationController.navigationBar];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_closeBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [_closeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_closeBtn];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestGetVerficationWithMobile:(NSString *)mobile{
    [self.tableView endEditing:YES];
    SHOWSVP
    
    [ECHTTPServer requestSendAuthcodeMessageWithMobileNumber:mobile succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result)
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestRegisterWithMobile:(NSString *)mobile WithPassword:(NSString *)password WithVerfication:(NSString *)verfication{
    [self.tableView endEditing:YES];
    SHOWSVP
    WEAK_SELF
    
    [ECHTTPServer requestRegisterWithUserName:mobile WithPassword:password WithVerficationCode:verfication succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result)
        if (IS_REQUEST_SUCCEED(result)) {
            [APP_DELEGATE loginSucceedActionWithRequestResult:result];
            [WEAKSELF_BASENAVI dismissViewControllerAnimated:YES completion:nil];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    
    ECRegisterTableViewCell *cell = [ECRegisterTableViewCell cellWithTableView:tableView];
    [cell setRegisterBlock:^(NSString *mobile, NSString *password, NSString *verfication) {
        if (password.length > 20 || password.length < 6) {
            [SVProgressHUD showInfoWithStatus:@"密码必须在6~20位之间"];
            return;
        }
        [weakSelf requestRegisterWithMobile:mobile WithPassword:password WithVerfication:verfication];
    }];
    [cell setGetVerficationBlock:^(NSString *mobile) {
        [weakSelf requestGetVerficationWithMobile:mobile];
    }];
    [cell setLoginBlock:^{
        [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
    }];
    [cell setAgreementBlock:^{
        ECAdvertisingViewController *advVC = [[ECAdvertisingViewController alloc] init];
        advVC.url =  [NSString stringWithFormat:@"%@%@/common/prot", HOST_ADDRESS, [ECHTTPServer loadApiVersion]];
        advVC.isHavRightNav = NO;
        [WEAKSELF_BASENAVI pushViewController:advVC animated:YES titleLabel:@"注册协议"];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
