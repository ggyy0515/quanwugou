//
//  ECAccountSecurityViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAccountSecurityViewController.h"
#import "ECMineTitleTableViewCell.h"

#import "ECAccountResetViewController.h"
#import "ECReplacePhoneViewController.h"
#import "ECAccountResetPasswordViewController.h"

@interface ECAccountSecurityViewController ()

@end

@implementation ECAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    [self createUI];
    [self addNotificationObserver];
}

- (void)addNotificationObserver{
    ADD_OBSERVER_NOTIFICATION(self, @selector(updateTableView), NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(updateTableView), NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)dealloc{
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)createUI{
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8.f);
        make.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(52.f * 5);
    }];
}

- (void)updateTableView{
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECMineTitleTableViewCell *cell = [ECMineTitleTableViewCell cellWithTableView:tableView];
    cell.titleFont = FONT_32;
    switch (indexPath.section) {
        case 0:{
            [cell setIconImage:nil WithTitle:@"更改绑定手机号"];
            cell.detailTitle = [NSString stringWithFormat:@"%@****%@",[[Keychain objectForKey:EC_PHONE] substringToIndex:3],[[Keychain objectForKey:EC_PHONE] substringFromIndex:7]];
            return cell;
        }
            break;
        default:{
            switch (indexPath.row) {
                case 0:{
                    [cell setIconImage:nil WithTitle:@"重置登录密码"];
                    cell.detailTitle = @"";
                    return cell;
                }
                    break;
                default:{
                    if ([[USERDEFAULT objectForKey:EC_USER_ISSETPAYWD] isEqualToString:@"0"]) {
                        [cell setIconImage:nil WithTitle:@"设置支付密码"];
                    }else{
                        [cell setIconImage:nil WithTitle:@"重置支付密码"];
                    }
                    cell.detailTitle = @"";
                    return cell;
                }
                    break;
            }
        }
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            ECReplacePhoneViewController *replacePhoneVC = [[ECReplacePhoneViewController alloc] init];
            [SELF_BASENAVI pushViewController:replacePhoneVC animated:YES titleLabel:@"更改绑定手机号"];
        }
            break;
        default:{
            if (indexPath.row == 0) {
                ECAccountResetViewController *accountResetVC = [[ECAccountResetViewController alloc] init];
                accountResetVC.type = 0;
                [SELF_BASENAVI pushViewController:accountResetVC animated:YES titleLabel:@"重置登录密码"];
            }else{
                if ([[USERDEFAULT objectForKey:EC_USER_ISSETPAYWD] isEqualToString:@"0"]) {
                    ECAccountResetPasswordViewController *vc = [[ECAccountResetPasswordViewController alloc] init];
                    vc.type = 2;
                    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"设置支付密码"];
                }else{
                    ECAccountResetViewController *accountResetVC = [[ECAccountResetViewController alloc] init];
                    accountResetVC.type = 1;
                    [SELF_BASENAVI pushViewController:accountResetVC animated:YES titleLabel:@"重置支付密码"];
                }
            }
        }
            break;
    }
}

@end
