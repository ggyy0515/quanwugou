//
//  ECAccountResetViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/2.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAccountResetViewController.h"
#import "ECAccountResetTableViewCell.h"

#import "ECAccountResetPhoneViewController.h"
#import "ECAccountResetPasswordViewController.h"

@interface ECAccountResetViewController ()

@end

@implementation ECAccountResetViewController

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECAccountResetTableViewCell *cell = [ECAccountResetTableViewCell cellWithTableView:tableView];
    cell.type = self.type;
    [cell setClickTypeBlock:^(NSInteger index) {
        switch (index) {
            case 0:{
                ECAccountResetPasswordViewController *vc = [[ECAccountResetPasswordViewController alloc] init];
                vc.type = weakSelf.type;
                [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:weakSelf.type == 0 ? @"重置登录密码" : @"重置支付密码"];
            }
                break;
            default:{
                ECAccountResetPhoneViewController *vc = [[ECAccountResetPhoneViewController alloc] init];
                vc.type = weakSelf.type;
                [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:weakSelf.type == 0 ? @"重置登录密码" : @"重置支付密码"];
            }
                break;
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return CGRectGetHeight(self.view.frame);
}

@end
