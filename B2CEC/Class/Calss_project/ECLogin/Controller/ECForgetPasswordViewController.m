//
//  ECForgetPasswordViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECForgetPasswordViewController.h"
#import "ECForgetPasswordTableViewCell.h"
#import "ECResetPasswordViewController.h"

@interface ECForgetPasswordViewController ()

@end

@implementation ECForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SELF_BASENAVI.titleLabel.textColor = MainColor;
    self.view.backgroundColor = BaseColor;
    [self createUI];
}

- (void)createUI{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = BaseColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestGetVerificationWithMobile:(NSString *)mobile{
    [self.tableView endEditing:YES];
    SHOWSVP
    
    [ECHTTPServer requestSendAuthcodeMessageWithMobileNumber:mobile succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result)
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestVailMobileWithMobile:(NSString *)mobile WithVerificationCode:(NSString *)verificationCode{
    [self.tableView endEditing:YES];
    SHOWSVP
    WEAK_SELF
    
    [ECHTTPServer requestVailMobileWithMobile:mobile WithVerfication:verificationCode succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result)
        if (IS_REQUEST_SUCCEED(result)) {
            ECResetPasswordViewController *resetPasswordVC = [[ECResetPasswordViewController alloc] init];
            resetPasswordVC.mobile = mobile;
            [WEAKSELF_BASENAVI pushViewController:resetPasswordVC animated:YES titleLabel:@"设置新密码"];
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
    ECForgetPasswordTableViewCell *cell = [ECForgetPasswordTableViewCell cellWithTableView:tableView];
    [cell setGetVerficationBlock:^(NSString *mobile) {
        [weakSelf requestGetVerificationWithMobile:mobile];
    }];
    [cell setNextStepBlock:^(NSString *mobile, NSString *verfication) {
        [weakSelf requestVailMobileWithMobile:mobile WithVerificationCode:verfication];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
