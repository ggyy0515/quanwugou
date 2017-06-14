//
//  ECTeamManagementViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTeamManagementViewController.h"
#import "ECTeamModel.h"
#import "ECTeamManagementTableViewCell.h"

#import "ECTeamDetailViewController.h"

@interface ECTeamManagementViewController ()

@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation ECTeamManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
    [self requestTeamData];
}

- (void)createData{
    _dataArray = [NSMutableArray new];
}

- (void)createUI{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享注册" style:UIBarButtonItemStylePlain target:self action:@selector(shareRegisterClick:)];
    self.navigationItem.rightBarButtonItem.tintColor = MainColor;
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)shareRegisterClick:(id)sender{
    [self requestGetShareRegister];
}

- (void)requestTeamData{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestTeamUsersucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            for (NSDictionary *dict in result[@"teamUsers"]) {
                ECTeamModel *model = [ECTeamModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
       RequestFailure
    }];
}

- (void)requestDeleteTeam:(NSInteger)index{
    SHOWSVP
    WEAK_SELF
    ECTeamModel *model = self.dataArray[index];
    [ECHTTPServer requestTeamDeleteWithUserID:model.USER_ID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            [SVProgressHUD showSuccessWithStatus:@"解除关系成功"];
            [weakSelf.dataArray removeObjectAtIndex:index];
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestGetShareRegister{
    SHOWSVP
    [ECHTTPServer requestGetShareRegistersucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            [CMPublicMethod shareToPlatformWithTitle:[NSString stringWithFormat:@"%@ 邀请您注册全屋构",[USERDEFAULT objectForKey:EC_USER_NICKNAME]] WithLink:result[@"shareUrl"] WithQCode:NO];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECTeamManagementTableViewCell *cell = [ECTeamManagementTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.row];
    cell.isShowNext = YES;
    NSMutableArray *array = [NSMutableArray new];
    [array sw_addUtilityButtonWithColor:CompColor title:@"解除关系"];
    [cell setRightUtilityButtons:array WithButtonWidth:80.f];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ECTeamModel *model = self.dataArray[indexPath.row];
    ECTeamDetailViewController *teamDetailVC = [[ECTeamDetailViewController alloc] init];
    teamDetailVC.userID = model.USER_ID;
    [SELF_BASENAVI pushViewController:teamDetailVC animated:YES titleLabel:@"三级"];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    WEAK_SELF
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                         andText:@"确认解除与该用户的关系吗"
                                                                 andCancelButton:YES
                                                                    forAlertType:AlertInfo
                                                           withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                               [weakSelf requestDeleteTeam:[weakSelf.tableView indexPathForCell:cell].row];
                                                           }];
    [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
    alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert.defaultButton setTitle:@"解除关系" forState:UIControlStateNormal];
    alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert show];
    
}

@end
