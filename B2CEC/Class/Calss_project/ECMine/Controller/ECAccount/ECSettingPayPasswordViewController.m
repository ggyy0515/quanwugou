//
//  ECSettingPayPasswordViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECSettingPayPasswordViewController.h"
#import "ECSettingPayPasswordTableViewCell.h"
#import "ECAccountSecurityViewController.h"

@interface ECSettingPayPasswordViewController ()

@end

@implementation ECSettingPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createUI{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = BaseColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestResetPasswordWithPassword:(NSString *)password{
    [self.tableView endEditing:YES];
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestChangePasswordWithLoginPassword:nil WithPayPassword:password succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            [USERDEFAULT setObject:@"1" forKey:EC_USER_ISSETPAYWD];
            UIViewController *popVC = nil;
            for (UIViewController *vc in WEAKSELF_BASENAVI.viewControllers) {
                if ([vc isKindOfClass:[ECAccountSecurityViewController class]]) {
                    popVC = vc;
                    [WEAKSELF_BASENAVI popToViewController:vc animated:YES];
                    break;
                }
            }
            if (!popVC) {
                [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
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
    ECSettingPayPasswordTableViewCell *cell = [ECSettingPayPasswordTableViewCell cellWithTableView:tableView];
    [cell setConfirmBlock:^(NSString *password) {
        [weakSelf requestResetPasswordWithPassword:password];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
