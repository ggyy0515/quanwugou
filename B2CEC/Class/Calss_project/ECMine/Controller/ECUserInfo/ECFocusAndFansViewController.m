//
//  ECFocusAndFansViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECFocusAndFansViewController.h"
#import "ECFocusAndFansTableViewCell.h"

#import "ECFocusAndFansModel.h"

@interface ECFocusAndFansViewController ()

@property (strong,nonatomic) UIView *navView;

@property (strong,nonatomic) UIButton *focusBtn;

@property (strong,nonatomic) UIButton *fansBtn;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) NSMutableArray *focusArray;

@property (strong,nonatomic) NSMutableArray *fansArray;

@property (assign,nonatomic) NSInteger focusPageIndex;

@property (assign,nonatomic) NSInteger fansPageIndex;

@end

@implementation ECFocusAndFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createNavUI];
    [self createUI];
}

- (void)createData{
    self.view.backgroundColor = [UIColor whiteColor];
    self.focusArray = [NSMutableArray new];
    self.fansArray = [NSMutableArray new];
}

- (void)createNavUI{
    WEAK_SELF
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREENWIDTH / 2.f, 44.f)];
    }
    
    if (!_focusBtn) {
        _focusBtn = [UIButton new];
    }
    [_focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_focusBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _focusBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_focusBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.type = 0;
        [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.focusBtn);
            make.bottom.mas_equalTo(weakSelf.focusBtn.mas_bottom);
            make.height.mas_equalTo(2.f);
        }];
        [weakSelf.navView setNeedsUpdateConstraints];
        [weakSelf.navView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25f animations:^{
            [weakSelf.navView layoutIfNeeded];
        }];
        if (weakSelf.focusArray.count == 0) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            [weakSelf.tableView reloadData];
        }
    }];
    
    if (!_fansBtn) {
        _fansBtn = [UIButton new];
    }
    [_fansBtn setTitle:@"粉丝" forState:UIControlStateNormal];
    [_fansBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _fansBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_fansBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.type = 1;
        [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.fansBtn);
            make.bottom.mas_equalTo(weakSelf.fansBtn.mas_bottom);
            make.height.mas_equalTo(2.f);
        }];
        [weakSelf.navView setNeedsUpdateConstraints];
        [weakSelf.navView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25f animations:^{
            [weakSelf.navView layoutIfNeeded];
        }];
        if (weakSelf.fansArray.count == 0) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            [weakSelf.tableView reloadData];
        }
    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = MainColor;
    
    [_navView addSubview:_focusBtn];
    [_navView addSubview:_fansBtn];
    [_navView addSubview:_lineView];
    
    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.right.mas_equalTo(weakSelf.navView.mas_centerX).offset(-20.f);
    }];
    
    [_fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.navView.mas_centerX).offset(20.f);
    }];
    
    if (self.type == 0) {
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.focusBtn);
            make.bottom.mas_equalTo(weakSelf.focusBtn.mas_bottom);
            make.height.mas_equalTo(2.f);
        }];
    }else{
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.fansBtn);
            make.bottom.mas_equalTo(weakSelf.fansBtn.mas_bottom);
            make.height.mas_equalTo(2.f);
        }];
    }
    self.navigationItem.titleView = _navView;
}

- (void)createUI{
    WEAK_SELF
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStyleGrouped;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.type == 0) {
            weakSelf.focusPageIndex = 1;
            [weakSelf requestFocusList];
        }else{
            weakSelf.fansPageIndex = 1;
            [weakSelf requestFansList];
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.type == 0) {
            weakSelf.focusPageIndex ++;
            [weakSelf requestFocusList];
        }else{
            weakSelf.fansPageIndex ++;
            [weakSelf requestFansList];
        }
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestFocusList{
    WEAK_SELF
    [ECHTTPServer requestFocusWithUserID:self.userID WithPageIndex:self.focusPageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.focusPageIndex == 1) {
                [weakSelf.focusArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"userAttentionList"]) {
                [weakSelf.focusArray addObject:[ECFocusAndFansModel yy_modelWithDictionary:dict]];
            }
            [weakSelf.tableView reloadData];
            if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.focusPageIndex) {
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

- (void)requestFansList{
    WEAK_SELF
    [ECHTTPServer requestFansWithUserID:self.userID WithPageIndex:self.fansPageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.fansPageIndex == 1) {
                [weakSelf.fansArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"userFansList"]) {
                [weakSelf.fansArray addObject:[ECFocusAndFansModel yy_modelWithDictionary:dict]];
            }
            [weakSelf.tableView reloadData];
            if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.fansPageIndex) {
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

- (void)requestFocusClickWithIndex:(NSInteger)index{
    SHOWSVP
    WEAK_SELF
    ECFocusAndFansModel *model = self.type == 0 ? self.focusArray[index] : self.fansArray[index];
    [ECHTTPServer requestFocusAndFansFocusWithUserID:model.USER_ID_TWO succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            ECFocusAndFansModel *mode = weakSelf.type == 0 ? weakSelf.focusArray[index] : weakSelf.fansArray[index];
            if ([mode.isAttention isEqualToString:@"1"] || mode.isAttention.length == 0) {
                mode.isAttention = @"0";
            }else{
                mode.isAttention = @"1";
            }
            [weakSelf.tableView reloadData];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.type) {
        case 0:{
            return self.focusArray.count;
        }
            break;
        default:{
            return self.fansArray.count;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECFocusAndFansTableViewCell *cell = [ECFocusAndFansTableViewCell cellWithTableView:tableView];
    cell.model = self.type == 0 ? self.focusArray[indexPath.row] : self.fansArray[indexPath.row];
    [cell setFocusClickBlock:^(NSInteger indexRow) {
        [weakSelf requestFocusClickWithIndex:indexRow];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78.f;
}

@end
