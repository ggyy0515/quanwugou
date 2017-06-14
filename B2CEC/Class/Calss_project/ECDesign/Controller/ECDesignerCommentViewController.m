//
//  ECDesignerCommentViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerCommentViewController.h"
#import "ECNewsBigInfoCommentView.h"
#import "ECNewsInfoCommentTableViewCell.h"
#import "ECWorksModel.h"

#import "ECUserInfoViewController.h"

@interface ECDesignerCommentViewController ()

@property (strong,nonatomic) ECNewsBigInfoCommentView *inputCommentView;

@property (strong,nonatomic) NSString *commentNum;

@property (assign,nonatomic) NSInteger pageIndex;

@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation ECDesignerCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    [self createData];
    [self createUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _inputCommentView.isBecomeInput = self.isEdit;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)createData{
    _dataArray = [NSMutableArray array];
}

- (void)createUI{
    WEAK_SELF
    
    if (!_inputCommentView) {
        _inputCommentView = [ECNewsBigInfoCommentView new];
    }
    _inputCommentView.hidden = YES;
    [_inputCommentView setSendCommentTextBlock:^(NSString *comment) {
        if (comment.length == 0 || [WJRegularVerify onlyContainSpace:comment]) {
            [SVProgressHUD showInfoWithStatus:@"请输入有效评论"];
            return ;
        }
        [weakSelf requestNewsSendCommentWithComment:comment];
    }];
    
    [self.view addSubview:_inputCommentView];
    
    [_inputCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0.f);
        make.height.mas_equalTo(49.f);
    }];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.bottom.mas_equalTo(weakSelf.inputCommentView.mas_top);
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf requestWorksComment];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestWorksComment];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setNavTitle{
    NSMutableAttributedString *attStr = [NSMutableAttributedString new];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"用户评论" attributes:@{NSForegroundColorAttributeName:MainColor,NSFontAttributeName:FONT_B_36}]];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)",self.commentNum] attributes:@{NSForegroundColorAttributeName:LightColor,NSFontAttributeName:FONT_28}]];
    SELF_BASENAVI.titleLabel.attributedText = attStr;
}

- (void)requestWorksComment{
    WEAK_SELF
    [ECHTTPServer requestGetWorksCommentWithWorksID:self.worksID WithPageIndex:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"commentList"]) {
                ECWorksCommentModel *model = [ECWorksCommentModel yy_modelWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
            weakSelf.commentNum = result[@"commentNum"];
            [weakSelf setNavTitle];
            
            weakSelf.inputCommentView.hidden = NO;
            
            if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.pageIndex) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            RequestError
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestNewsSendCommentWithComment:(NSString *)comment{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestWorksSendCommentWithWorksID:self.worksID WithContent:comment succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.sendCommentTextBlock) {
                weakSelf.sendCommentTextBlock();
            }
            [weakSelf.tableView.mj_header beginRefreshing];
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
    ECNewsInfoCommentTableViewCell *cell = [ECNewsInfoCommentTableViewCell cellWithTableView:tableView];
    ECWorksCommentModel *model = [self.dataArray objectAtIndexWithCheck:indexPath.row];
    cell.title_img = model.title_img;
    cell.name = model.name;
    cell.edittime = model.edittime;
    cell.content = model.content;
    cell.userID = model.user_id;
    [cell setIconClickBlock:^(NSString *userID) {
        ECUserInfoViewController *userInfoVC = [[ECUserInfoViewController alloc] init];
        userInfoVC.userid = userID;
        userInfoVC.isEdit = NO;
        [WEAKSELF_BASENAVI pushViewController:userInfoVC animated:YES titleLabel:@"个人信息"];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECWorksCommentModel *mode = [self.dataArray objectAtIndexWithCheck:indexPath.row];
    return [CMPublicMethod getHeightWithContent:mode.content width:(SCREENWIDTH - 66.f) font:16.f] + 104.f;
}

@end
