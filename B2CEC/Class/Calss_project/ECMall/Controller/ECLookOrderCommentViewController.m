//
//  ECLookOrderCommentViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2017/1/18.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "ECLookOrderCommentViewController.h"
#import "ECOrderCommentTableViewCell.h"
#import "ECOrderCommentModel.h"

@interface ECLookOrderCommentViewController ()

@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation ECLookOrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
    [self requestOrderComment];
}

- (void)createData{
    self.view.backgroundColor = BaseColor;
    self.dataArray = [NSMutableArray new];
}

- (void)createUI{
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStyleGrouped;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestOrderComment{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestOrderCommentListWithOrderID:self.orderID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            for (NSDictionary *dict in result[@"orderCommentList"]) {
                ECOrderCommentModel *model = [ECOrderCommentModel yy_modelWithDictionary:dict];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECOrderCommentTableViewCell *cell = [ECOrderCommentTableViewCell cellWithTableView:tableView];
    cell.model = [self.dataArray objectAtIndexWithCheck:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECOrderCommentModel *model = [self.dataArray objectAtIndexWithCheck:indexPath.section];
    CGFloat height = 112.f + [CMPublicMethod getHeightWithContent:model.comment width:(SCREENWIDTH - 16.f) font:16.f];
    if (model.imgurls.count != 0) {
        height += (20.f + (SCREENWIDTH - 12.f * 6) / 5.f);
    }
    return height;
}

@end
