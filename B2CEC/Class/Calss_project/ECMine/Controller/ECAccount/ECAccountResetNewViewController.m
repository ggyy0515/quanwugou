//
//  ECAccountResetNewViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAccountResetNewViewController.h"
#import "ECAccountResetPasswordTableViewCell.h"
#import "ECAccountSecurityViewController.h"

@interface ECAccountResetNewViewController ()

@property (strong,nonatomic) NSString *password;

@end

@implementation ECAccountResetNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    [self createUI];
}

- (void)createUI{
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestChangePassword{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestChangePasswordWithLoginPassword:self.type != 1 ? self.password : nil WithPayPassword:self.type == 1 ? self.password : nil succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            for (UIViewController *vc in WEAKSELF_BASENAVI.viewControllers) {
                if ([vc isKindOfClass:[ECAccountSecurityViewController class]]) {
                    [WEAKSELF_BASENAVI popToViewController:vc animated:YES];
                    break;
                }
            }
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
    ECAccountResetPasswordTableViewCell *cell = [ECAccountResetPasswordTableViewCell cellWithTableView:tableView];
    cell.tips = self.type == 0 ? @"请输入新的登录密码" : @"请输入新的支付密码";
    cell.name = self.type == 0 ? @"登录密码" : @"支付密码";
    cell.placeholder = self.type == 0 ? @"输入登录密码" : @"输入支付密码";
    cell.submitStr = @"完成";
    cell.isSecureTextEntry = YES;
    [cell setNextStepBlock:^(NSString *password) {
        if (weakSelf.type == 0) {
            if (password.length < 6 || password.length > 16) {
                [SVProgressHUD showErrorWithStatus:@"请输入6-16位数字字母组合的密码"];
                return;
            }
            weakSelf.password = password;
            [weakSelf requestChangePassword];
        }else{
            if (![CMPublicMethod isValidateNumber:password]) {
                [SVProgressHUD showErrorWithStatus:@"请输入6位有效数字"];
                return ;
            }
            weakSelf.password = password;
            [weakSelf requestChangePassword];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
