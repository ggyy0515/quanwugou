//
//  ECReplacePhoneNewViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECReplacePhoneNewViewController.h"
#import "ECAccountResetPasswordTableViewCell.h"
#import "ECReplacePhoneSetViewController.h"

@interface ECReplacePhoneNewViewController ()

@property (strong,nonatomic) NSString *phone;

@end

@implementation ECReplacePhoneNewViewController

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

- (void)requestValidPhoneExist{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestValidPhoneExistWithPhone:self.phone succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            ECReplacePhoneSetViewController *vc = [[ECReplacePhoneSetViewController alloc] init];
            vc.phone = weakSelf.phone;
            [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"更改绑定手机号"];
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
    cell.tips = @"请输入新的手机号";
    cell.name = @"新手机号";
    cell.placeholder = @"请输入新的手机号";
    cell.bottomTips = @"注意：更换手机号就等于更换登录账号";
    [cell setNextStepBlock:^(NSString *phone) {
        if (phone.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入新手机号码"];
            return ;
        }
        if (![WJRegularVerify phoneNumberVerify:phone]) {
            [SVProgressHUD showErrorWithStatus:@"请输入有效的手机号码"];
            return ;
        }
        weakSelf.phone = phone;
        [weakSelf requestValidPhoneExist];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
