//
//  ECResetPasswordViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECResetPasswordViewController.h"
#import "ECResetPasswordTableViewCell.h"

@interface ECResetPasswordViewController ()

@end

@implementation ECResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SELF_BASENAVI.titleLabel.textColor = MainColor;
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
    
    [ECHTTPServer requestResetPasswordWithMobile:self.mobile WithPassword:password succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result)
        if (IS_REQUEST_SUCCEED(result)) {
            [WEAKSELF_BASENAVI popToRootViewControllerAnimated:YES];
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
    ECResetPasswordTableViewCell *cell = [ECResetPasswordTableViewCell cellWithTableView:tableView];
    [cell setConfirmBlock:^(NSString *password) {
        [weakSelf requestResetPasswordWithPassword:password];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
