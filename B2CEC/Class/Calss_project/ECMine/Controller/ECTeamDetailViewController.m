//
//  ECTeamDetailViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTeamDetailViewController.h"
#import "ECTeamModel.h"
#import "ECTeamManagementTableViewCell.h"

@interface ECTeamDetailViewController ()

@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation ECTeamDetailViewController

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
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestTeamData{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestTeamDetailWithUserID:self.userID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            for (NSDictionary *dict in result[@"subteamUsers"]) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECTeamManagementTableViewCell *cell = [ECTeamManagementTableViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    cell.isShowNext = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

@end
