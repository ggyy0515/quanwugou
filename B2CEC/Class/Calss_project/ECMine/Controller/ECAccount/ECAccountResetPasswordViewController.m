//
//  ECAccountResetPasswordViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAccountResetPasswordViewController.h"
#import "ECAccountResetPasswordTableViewCell.h"
#import "ECAccountResetNewViewController.h"
#import "ECSettingPayPasswordViewController.h"

@interface ECAccountResetPasswordViewController ()

@end

@implementation ECAccountResetPasswordViewController

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
    [ECHTTPServer requestValidPasswordWithLoginPassword:self.type != 1 ? password : nil WithPayPassword:self.type == 1 ? password : nil succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            if (weakSelf.type == 2) {
                //设置支付密码
                ECSettingPayPasswordViewController *settingPayPasswordVC = [[ECSettingPayPasswordViewController alloc] init];
                [WEAKSELF_BASENAVI pushViewController:settingPayPasswordVC animated:YES titleLabel:@"设置支付密码"];
            }else{
                ECAccountResetNewViewController *vc = [[ECAccountResetNewViewController alloc] init];
                vc.type = weakSelf.type;
                [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:weakSelf.type == 0 ? @"重置登录密码" : @"重置支付密码"];
            }
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
    switch (self.type) {
        case 0:{
            cell.tips = @"请输入原登录密码以验证身份";
            cell.name = @"登录密码";
            cell.placeholder = @"输入原登录密码";
        }
            break;
        case 1:{
            cell.tips = @"请输入原支付密码以验证身份";
            cell.name = @"支付密码";
            cell.placeholder = @"输入原支付密码";
        }
            break;
        default:{
            cell.tips = @"请输入登录密码以验证身份";
            cell.name = @"登录密码";
            cell.placeholder = @"输入登录密码";
        }
            break;
    }
    cell.isSecureTextEntry = YES;
    [cell setNextStepBlock:^(NSString *password) {
        if (password.length == 0) {
            [SVProgressHUD showInfoWithStatus:weakSelf.type == 1 ? @"输入支付密码" : @"输入登录密码"];
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
