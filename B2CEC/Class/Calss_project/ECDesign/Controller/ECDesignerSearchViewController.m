//
//  ECDesignerSearchViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerSearchViewController.h"

#import "ECDesignerTableViewCell.h"
#import "ECDesignerModel.h"
#import "ECUserInfoViewController.h"

#import "ECWorksTableViewCell.h"
#import "ECWorksModel.h"
#import "ECWorksDetailViewController.h"

@interface ECDesignerSearchViewController ()

@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, strong) UIButton *searchBtn;

@property (strong,nonatomic) UIView *topView;

@property (strong,nonatomic) UIButton *userBtn;

@property (strong,nonatomic) UIButton *workBtn;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) NSMutableArray *dataArray;

@property (assign,nonatomic) NSInteger pageIndex;

@property (assign,nonatomic) NSInteger type;

@end

@implementation ECDesignerSearchViewController

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
    self.type = 1;
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
    
    if (!_topView) {
        _topView = [UIView new];
    }
    _topView.backgroundColor = LineDefaultsColor;
    
    if (!_userBtn) {
        _userBtn = [UIButton new];
    }
    [_userBtn setTitle:@"设计师" forState:UIControlStateNormal];
    [_userBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _userBtn.titleLabel.font = FONT_32;
    _userBtn.backgroundColor = [UIColor whiteColor];
    [_userBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.type == 1) {
            return ;
        }
        weakSelf.type = 1;
        [weakSelf clickTypeUpdateUI];
    }];
    
    if (!_workBtn) {
        _workBtn = [UIButton new];
    }
    [_workBtn setTitle:@"案例" forState:UIControlStateNormal];
    [_workBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
    _workBtn.titleLabel.font = FONT_32;
    _workBtn.backgroundColor = [UIColor whiteColor];
    [_workBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.type == 2) {
            return ;
        }
        weakSelf.type = 2;
        [weakSelf clickTypeUpdateUI];
    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = MainColor;
    
    [self.view addSubview:_topView];
    [_topView addSubview:_userBtn];
    [_topView addSubview:_workBtn];
    [_topView addSubview:_lineView];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestDesignerSearch];
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(49.f);
    }];
    
    [_userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.workBtn.mas_left).offset(-0.5f);
        make.width.mas_equalTo(weakSelf.workBtn.mas_width);
    }];
    
    [_workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0.f);
        make.width.mas_equalTo(weakSelf.userBtn.mas_width);
        make.left.mas_equalTo(weakSelf.userBtn.mas_right).offset(0.5f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.userBtn);
        make.bottom.mas_equalTo(weakSelf.userBtn.mas_bottom);
        make.height.mas_equalTo(2.f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom);
    }];
}

- (void)clickTypeUpdateUI{
    //控制底部细线移动
    switch (self.type) {
        case 1:{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.userBtn);
                make.bottom.mas_equalTo(self.userBtn.mas_bottom);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
        case 2:{
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.workBtn);
                make.bottom.mas_equalTo(self.workBtn.mas_bottom);
                make.height.mas_equalTo(2.f);
            }];
        }
            break;
    }
    [self.topView setNeedsUpdateConstraints];
    [self.topView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25f animations:^{
        [self.topView layoutIfNeeded];
    }];
    [self search];
}

- (void)search{
    if (_searchTF.text.length == 0 || [WJRegularVerify onlyContainSpace:_searchTF.text]) {
        [CMPublicMethod showInfoWithString:@"请输入要搜索的内容"];
        return;
    }
    [_searchTF endEditing:YES];
    [self.view endEditing:YES];
    _pageIndex = 1;
    [self requestDesignerSearch];
}

- (void)requestDesignerSearch{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestDesignerSearchWithtype:self.type WithKey:_searchTF.text WithPageIndex:_pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            if (weakSelf.type == 1) {
                for (NSDictionary *dict in result[@"designList"]) {
                    [weakSelf.dataArray addObject:[ECDesignerModel yy_modelWithDictionary:dict]];
                }
            }else{
                for (NSDictionary *dict in result[@"caseList"]) {
                    [weakSelf.dataArray addObject:[ECWorksModel yy_modelWithDictionary:dict]];
                }
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

- (void)requestFocusClickWithIndex:(NSInteger)index{
    SHOWSVP
    WEAK_SELF
    ECDesignerModel *model = self.dataArray[index];
    [ECHTTPServer requestFocusAndFansFocusWithUserID:model.USER_ID succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            ECDesignerModel *mode = weakSelf.dataArray[index];
            if ([mode.ATTENTION isEqualToString:@"1"] || mode.ATTENTION.length == 0) {
                mode.ATTENTION = @"0";
            }else{
                mode.ATTENTION = @"1";
            }
            [weakSelf.tableView reloadData];
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
    switch (self.type) {
        case 1:{
            ECDesignerTableViewCell *cell = [ECDesignerTableViewCell cellWithTableView:tableView];
            [cell setFocusClickBlock:^(NSInteger row) {
                if (EC_USER_WHETHERLOGIN) {
                    [weakSelf requestFocusClickWithIndex:row];
                }else{
                    [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
                    }];
                }
            }];
            cell.model = self.dataArray[indexPath.row];
            return cell;
        }
            break;
        case 2:{
            ECWorksTableViewCell *cell = [ECWorksTableViewCell cellWithTableView:tableView];
            cell.model = self.dataArray[indexPath.row];
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
    switch (self.type) {
        case 1:{
            return 93.f + SCREENWIDTH * (168.f / 750.f);
        }
            break;
        case 2:{
            return 101.f + SCREENWIDTH * (350.f / 750.f);
        }
            break;
        default:{
            return 0.f;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case 1:{
            ECDesignerModel *model = self.dataArray[indexPath.row];
            ECUserInfoViewController *userInfoVC = [[ECUserInfoViewController alloc] init];
            userInfoVC.userid = model.USER_ID;
            userInfoVC.isEdit = NO;
            [SELF_BASENAVI pushViewController:userInfoVC animated:YES titleLabel:@""];
        }
            break;
        case 2:{
            ECWorksModel *model = self.dataArray[indexPath.row];
            ECWorksDetailViewController *worksDetailVC = [[ECWorksDetailViewController alloc] init];
            worksDetailVC.worksID = model.worksID;
            [SELF_BASENAVI pushViewController:worksDetailVC animated:YES titleLabel:@"详情"];
        }
            break;
        default:{
        }
            break;
    }
}

@end
