//
//  ECNoticePushView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNoticePushView.h"
#import "ECNoticePushTableViewCell.h"
#import "ECNoticePushModel.h"

@interface ECNoticePushView()<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArray;

@property (strong,nonatomic) NSMutableArray *showArray;

@property (assign,nonatomic) NSInteger pageIndex;

@end

@implementation ECNoticePushView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSMutableArray new];
        self.showArray = [NSMutableArray new];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    WEAK_SELF
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf requestPushList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestPushList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestPushList{
    WEAK_SELF
    [ECHTTPServer requestPushList:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.showArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"list"]) {
                ECNoticePushModel *model = [ECNoticePushModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
                [weakSelf.showArray addObject:@(NO)];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECNoticePushTableViewCell *cell = [ECNoticePushTableViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    cell.isShowAll = [[self.showArray objectAtIndex:indexPath.row] boolValue];
    [cell setShowAllBlock:^(NSInteger row) {
        BOOL isShowAll = [[weakSelf.showArray objectAtIndexWithCheck:row] boolValue];
        [weakSelf.showArray replaceObjectAtIndex:row withObject:@(!isShowAll)];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 166.f;
    
    ECNoticePushModel *model = self.dataArray[indexPath.row];
    CGFloat contentHeight = [CMPublicMethod getHeightWithContent:model.content width:(SCREENWIDTH - 48.f) font:14.f] + 14.f;
    if ([[self.showArray objectAtIndex:indexPath.row] boolValue]) {
        height += contentHeight;
    }else{
        if (contentHeight >= 94.f) {
            height += 94.f;
        }else{
            height += contentHeight;
        }
    }
    return height;
}

@end
