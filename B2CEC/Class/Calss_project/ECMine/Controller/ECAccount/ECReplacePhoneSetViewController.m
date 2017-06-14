//
//  ECReplacePhoneSetViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECReplacePhoneSetViewController.h"
#import "ECAccountResetPhoneTableViewCell.h"
#import "ECAccountSecurityViewController.h"

@interface ECReplacePhoneSetViewController ()

@end

@implementation ECReplacePhoneSetViewController

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

- (void)setPhone:(NSString *)phone{
    _phone = phone;
    [self requestGetCode];
}

- (void)requestGetCode{
    SHOWSVP
    [ECHTTPServer requestSendAuthcodeMessageWithMobileNumber:self.phone succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestChangeMobile:(NSString *)code{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestChangeMobileWithMobile:self.phone WithCode:code succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:YES clearCurrentLoginInfo:YES succeed:^{
                
            }];
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
    ECAccountResetPhoneTableViewCell *cell = [ECAccountResetPhoneTableViewCell cellWithTableView:tableView];
    cell.tips = [NSString stringWithFormat:@"我们已发送校验码到新手机%@",self.phone];
    cell.submitStr = @"完成";
    [cell setNextStepBlock:^(NSString *code) {
        if (code.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
            return ;
        }
        [weakSelf requestChangeMobile:code];
    }];
    [cell setGetVerficationBlock:^{
        [weakSelf requestGetCode];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
