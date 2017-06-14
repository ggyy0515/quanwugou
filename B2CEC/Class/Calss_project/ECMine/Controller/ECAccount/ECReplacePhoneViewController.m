//
//  ECReplacePhoneViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECReplacePhoneViewController.h"
#import "ECAccountResetPasswordTableViewCell.h"
#import "ECReplacePhoneNewViewController.h"

@interface ECReplacePhoneViewController ()

@end

@implementation ECReplacePhoneViewController

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

- (void)requestValidPassword:(NSString *)password{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestValidPasswordWithLoginPassword:password WithPayPassword:nil succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            ECReplacePhoneNewViewController *vc = [[ECReplacePhoneNewViewController alloc] init];
            [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"更改绑定手机号"];
        }else{
            RequestSuccess(result);
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
    cell.tips = @"请输入原登录密码以验证身份";
    cell.name = @"登录密码";
    cell.placeholder = @"输入原登录密码";
    cell.isSecureTextEntry = YES;
    [cell setNextStepBlock:^(NSString *password) {
        if (password.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入登录密码"];
            return ;
        }
        [weakSelf requestValidPassword:password];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
