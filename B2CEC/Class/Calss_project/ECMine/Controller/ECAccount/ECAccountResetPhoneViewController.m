//
//  ECAccountResetPhoneViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAccountResetPhoneViewController.h"
#import "ECAccountResetPhoneTableViewCell.h"
#import "ECAccountResetNewViewController.h"

@interface ECAccountResetPhoneViewController ()

@property (strong,nonatomic) NSString *code;

@end

@implementation ECAccountResetPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    [self createUI];
    [self requestGetCode];
}

- (void)createUI{
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestGetCode{
    SHOWSVP
    [ECHTTPServer requestSendAuthcodeMessageWithMobileNumber:[Keychain objectForKey:EC_PHONE] succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestCheckCode{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestValidAuthCodeWithPhone:[Keychain objectForKey:EC_PHONE] WithCode:self.code succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            ECAccountResetNewViewController *vc = [[ECAccountResetNewViewController alloc] init];
            vc.type = weakSelf.type;
            [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:weakSelf.type == 0 ? @"重置登录密码" : @"重置支付密码"];
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
    ECAccountResetPhoneTableViewCell *cell = [ECAccountResetPhoneTableViewCell cellWithTableView:tableView];
    cell.tips = [NSString stringWithFormat:@"我们已发送校验码到手机%@",[CMPublicMethod mobilePhoneNumberIntoAStarMobile:[Keychain objectForKey:EC_PHONE]]];
    [cell setNextStepBlock:^(NSString *code) {
        weakSelf.code = code;
        [weakSelf requestCheckCode];
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
