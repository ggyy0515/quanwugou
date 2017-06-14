//
//  ECNewsSearchViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsSearchViewController.h"
#import "ECHomeSingleImageTableViewCell.h"
#import "ECHomeMoreImageTableViewCell.h"
#import "ECHomeNoneImageTableViewCell.h"
#import "ECHomeBigImageTableViewCell.h"
#import "ECHomeAdvertisingTableViewCell.h"
#import "ECHomeVideoTableViewCell.h"

#import "WJRegularVerify.h"
#import "ECHomeNewsListModel.h"

#import "ECAdvertisingViewController.h"
#import "ECNewsBigImageViewViewController.h"
#import "ECNewsVideoInfoViewController.h"
#import "ECNewsInfoViewController.h"

@interface ECNewsSearchViewController ()

@property (strong,nonatomic) NSMutableArray *dataArray;

@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, strong) UIButton *searchBtn;

@property (assign,nonatomic) NSInteger pageIndex;

@end

@implementation ECNewsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchTF becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_searchTF resignFirstResponder];
}

- (void)createData{
    _dataArray = [NSMutableArray array];
}

- (void)createUI{
    WEAK_SELF
    //搜索栏
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 56.0 / 75.0 * SCREENWIDTH, 33)];
    }
    _searchTF.placeholder = @"输入搜索";
    _searchTF.backgroundColor = OptionsBaseColor;
    _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_searchTF setLeftViewMode:UITextFieldViewModeAlways];
    _searchTF.layer.masksToBounds = YES;
    _searchTF.layer.cornerRadius = 5.f;
    _searchTF.font = FONT_28;
    _searchTF.textColor = DarkMoreColor;
    self.navigationItem.titleView = _searchTF;
    //搜索按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0.f);
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestNewsSearch];
    }];
}

- (void)search{
    if (_searchTF.text.length == 0 || [WJRegularVerify onlyContainSpace:_searchTF.text]) {
        [CMPublicMethod showInfoWithString:@"请输入要搜索的内容"];
        return;
    }
    [_searchTF endEditing:YES];
    [self.view endEditing:YES];
    _pageIndex = 1;
    [self requestNewsSearch];
}

- (void)requestNewsSearch{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestNewsSearchWithSearchKey:_searchTF.text WithPageIndex:_pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"inforList"]) {
                ECHomeNewsListModel *model = [ECHomeNewsListModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
            
            [weakSelf.tableView reloadData];
            
            if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.pageIndex) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECHomeNewsListModel *model = self.dataArray[indexPath.row];
    switch (model.inforType.integerValue) {
        case 0:{//单图
            ECHomeSingleImageTableViewCell *cell = [ECHomeSingleImageTableViewCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        }
            break;
        case 1:{//多图
            ECHomeMoreImageTableViewCell *cell = [ECHomeMoreImageTableViewCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        }
            break;
        case 2:{//无图
            ECHomeNoneImageTableViewCell *cell = [ECHomeNoneImageTableViewCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        }
            break;
        case 3:{//大图
            ECHomeBigImageTableViewCell *cell = [ECHomeBigImageTableViewCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        }
            break;
        case 4:{//广告
            ECHomeAdvertisingTableViewCell *cell = [ECHomeAdvertisingTableViewCell cellWithTableView:tableView];
            cell.imageUrl = model.cover1;
            cell.title = model.title;
            return cell;
        }
            break;
        case 6:{//不可直接播放视频
            ECHomeVideoTableViewCell *cell = [ECHomeVideoTableViewCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        }
            break;
        default:{
            return nil;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECHomeNewsListModel *model = self.dataArray[indexPath.row];
    switch (model.inforType.integerValue) {
        case 0:{//单图
            return 108.f;
        }
            break;
        case 1:{//多图
            
            return 66.f + [CMPublicMethod getHeightWithContent:model.title width:(SCREENWIDTH - 36.f) font:18.f] + (SCREENWIDTH - 45.f) / 3 * (144.f / 220.f);
        }
            break;
        case 2:{//无图
            return 107.f;
        }
            break;
        case 3:{//大图
            return 66.f + [CMPublicMethod getHeightWithContent:model.title width:(SCREENWIDTH - 36.f) font:18.f] + (SCREENWIDTH - 36.f) * (382.f / 678.f);
        }
            break;
        case 4:{//广告
            return 64.f + (SCREENWIDTH - 36.f) * (190.f / 678.f);
        }
            break;
        case 5:{//直接播放视频
            return 44.f + SCREENWIDTH * (422.f / 750.f);
        }
            break;
        case 6:{//不可直接播放视频
            return 66.f + [CMPublicMethod getHeightWithContent:model.title width:(SCREENWIDTH - 36.f) font:18.f] + (SCREENWIDTH - 36.f) * (382.f / 678.f);
        }
            break;
        default:{
            return 0.f;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECHomeNewsListModel *model = self.dataArray[indexPath.row];
    __block ECHomeNewsListModel *weakModel = model;
    switch (model.inforType.integerValue) {
        case 0://单图
        case 1://多图
        case 2:{//无图
            ECNewsInfoViewController *newsInfoVC = [[ECNewsInfoViewController alloc] init];
            newsInfoVC.BIANMA = model.classify;
            newsInfoVC.informationId = model.newsID;
            [SELF_BASENAVI pushViewController:newsInfoVC animated:YES titleLabel:model.resource];
            
            [newsInfoVC setSendCommentTextBlock:^{
                weakModel.commentNum = [NSString stringWithFormat:@"%ld",weakModel.commentNum.integerValue + 1];
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        case 3:{//大图
            ECNewsBigImageViewViewController *newsBigImageVC = [[ECNewsBigImageViewViewController alloc] init];
            newsBigImageVC.BIANMA = model.classify;
            newsBigImageVC.informationId = model.newsID;
            [SELF_BASENAVI pushViewController:newsBigImageVC animated:YES titleLabel:model.title];
            
            [newsBigImageVC setSendCommentTextBlock:^{
                weakModel.commentNum = [NSString stringWithFormat:@"%ld",weakModel.commentNum.integerValue + 1];
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        case 4:{//广告
            ECAdvertisingViewController *advertisingVC = [[ECAdvertisingViewController alloc] init];
            advertisingVC.url = model.weburl;
            advertisingVC.isHavRightNav = NO;
            [SELF_BASENAVI pushViewController:advertisingVC animated:YES titleLabel:model.title];
        }
            break;
        case 5://直接播放视频
        case 6:{//不可直接播放视频
            ECNewsVideoInfoViewController *videoInfoVC = [[ECNewsVideoInfoViewController alloc] init];
            videoInfoVC.BIANMA = model.classify;
            videoInfoVC.informationId = model.newsID;
            [SELF_BASENAVI pushViewController:videoInfoVC animated:YES titleLabel:model.resource];
            
            [videoInfoVC setSendCommentTextBlock:^{
                weakModel.commentNum = [NSString stringWithFormat:@"%ld",weakModel.commentNum.integerValue + 1];
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        default:{
        }
            break;
    }
}

@end
