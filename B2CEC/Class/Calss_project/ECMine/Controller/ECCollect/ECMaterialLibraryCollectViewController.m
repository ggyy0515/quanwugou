//
//  ECMaterialLibraryCollectViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMaterialLibraryCollectViewController.h"
#import "ECMaterialLibraryModel.h"
#import "ECMaterialLibrarTableViewCell.h"

@interface ECMaterialLibraryCollectViewController ()

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (assign,nonatomic) NSInteger pageIndex;

@end

@implementation ECMaterialLibraryCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}

- (void)createData{
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray new];
}

- (void)createUI{
    WEAK_SELF
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0.f);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf requestMaterialLibraryData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestMaterialLibraryData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestMaterialLibraryData{
    WEAK_SELF
    [ECHTTPServer requestMyCollectWithType:4 WithPageIndex:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"materialList"]) {
                [weakSelf.dataArray addObject:[ECMaterialLibraryModel yy_modelWithDictionary:dict]];
            }
            [weakSelf.tableView reloadData];
            if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.pageIndex) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestCollect:(NSInteger)row{
    SHOWSVP
    WEAK_SELF
    ECMaterialLibraryModel *model = [self.dataArray objectAtIndexWithCheck:row];
    [ECHTTPServer requestCollectMaterialLibrary:model.libID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            ECMaterialLibraryModel *weakModel = [weakSelf.dataArray objectAtIndexWithCheck:row];
            if ([weakModel.isCollect isEqualToString:@"0"]) {
                weakModel.isCollect = @"1";
                weakModel.collect = [NSString stringWithFormat:@"%ld",weakModel.collect.integerValue + 1];
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }else{
                weakModel.isCollect = @"0";
                weakModel.collect = [NSString stringWithFormat:@"%ld",weakModel.collect.integerValue - 1];
                [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
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
    WEAK_SELF
    ECMaterialLibrarTableViewCell *cell = [ECMaterialLibrarTableViewCell cellWithTableView:tableView];
    cell.model = [self.dataArray objectAtIndexWithCheck:indexPath.row];
    [cell setCollectBlock:^(NSInteger row) {
        [weakSelf requestCollect:row];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 101.f + SCREENWIDTH * (350.f / 750.f);
}

@end
