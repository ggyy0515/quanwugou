//
//  ECBindMobileViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECBindMobileViewController.h"
#import "ECBindMobileTableViewCell.h"

@interface ECBindMobileViewController ()

@end

@implementation ECBindMobileViewController

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

- (void)requestGetVerficationWithMobile:(NSString *)mobile{
    [self.tableView endEditing:YES];
    SHOWSVP
    
    [ECHTTPServer requestSendAuthcodeMessageWithMobileNumber:mobile succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result)
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestBindMobileWithMobile:(NSString *)mobile WithPassword:(NSString *)password WithCode:(NSString *)code{
    WEAK_SELF
    SHOWSVP
    [ECHTTPServer requestBindMobileWithQQUid:self.type == UMSocialPlatformType_QQ ? @"" : self.userinfo.uid
                               WithWeixinUid:self.type == UMSocialPlatformType_WechatSession ? @"" : self.userinfo.uid WithMobil:mobile WithPassword:password WithCode:code WithIconurl:self.userinfo.iconurl WithName:self.userinfo.name succeed:^(NSURLSessionDataTask *task, id result) {
                                   RequestSuccess(result);
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
    ECBindMobileTableViewCell *cell = [ECBindMobileTableViewCell cellWithTableView:tableView];
    [cell setGetVerficationBlock:^(NSString *mobile) {
        [weakSelf requestGetVerficationWithMobile:mobile];
    }];
    [cell setNextStepBlock:^(NSString *mobile,NSString *password,NSString *verfication) {
        [weakSelf requestBindMobileWithMobile:mobile WithPassword:password WithCode:verfication];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

@end
