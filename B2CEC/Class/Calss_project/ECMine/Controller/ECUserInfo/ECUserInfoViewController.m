//
//  ECUserInfoViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/5.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoViewController.h"
#import "ECUserInfoAddPopView.h"
#import "ECUserInfoHeaderTableViewCell.h"
#import "ECUserInfoTypeTableViewCell.h"

#import "ECUserInfomationTableViewCell.h"
#import "ECUserInfoDesignerResumeTableViewCell.h"
#import "ECUserInfoDesignerExpressTableViewCell.h"

#import "ECWorksTableViewCell.h"

#import "ECLogsTableViewCell.h"

#import "ECUserInfoEvaluationStartTableViewCell.h"
#import "ECUserInfoEvaluationCommentTableViewCell.h"

#import "ECUserInfoModel.h"
#import "ECWorksModel.h"
#import "ECUserInfoCommentModel.h"

#import "ECFocusAndFansViewController.h"
#import "ECUserInfoEditViewController.h"
#import "ECPostWorksViewController.h"
#import "ECPostLogsViewController.h"
#import "ECWorksDetailViewController.h"
#import "ECPlaceOrderViewController.h"

#import "ChatViewController.h"
#import "ECChatListModel.h"

@interface ECUserInfoViewController ()

@property (strong,nonatomic) UIView *navView;

@property (strong,nonatomic) UIView *navBottomView;

@property (strong,nonatomic) UIButton *backBtn;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIButton *addBtn;

@property (strong,nonatomic) ECUserInfoAddPopView *popView;
//查看非当前用户设计师时会出现，用于聊天、关注、下订单
@property (strong,nonatomic) UIView *bottomView;

@property (strong,nonatomic) UIButton *orderBtn;

@property (strong,nonatomic) UIButton *chatBtn;

@property (strong,nonatomic) UIButton *focusBtn;
//0:简介 1：作品 2：日志 3：评价 4：普通用户文章
@property (assign,nonatomic) NSInteger type;

@property (strong,nonatomic) ECUserInfoModel *userInfoModel;

@property (assign,nonatomic) BOOL isNeedLoadHtml;

@property (assign,nonatomic) CGFloat htmlHeight;

@property (strong,nonatomic) NSString *commentScore;

@property (assign,nonatomic) NSInteger pageIndex;

@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation ECUserInfoViewController

- (void)addNotificationObserver{
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestUserInfo), NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestUserInfo), NOTIFICATION_USER_LOGIN_EXIST, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestUserInfo), NOTIFICATION_USER_DESIGNER_REGISTER, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestUserInfo), NOTIFICATION_USER_UPDATE_USERINFO, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(updateRequest:), NOTIFICATION_POSTWORKS_LOGS_ARTICLE, nil);
    
}

- (void)dealloc{
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_EXIST, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_DESIGNER_REGISTER, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_UPDATE_USERINFO, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_POSTWORKS_LOGS_ARTICLE, nil);
}

- (void)updateRequest:(NSNotification *)notification{
    NSInteger type = [notification.object[@"type"] integerValue];
    switch (type) {
        case 0:{//文章
            self.type = 4;
            [self.tableView.mj_header beginRefreshing];
        }
            break;
        case 1:{//作品
            self.type = 1;
            [self.tableView.mj_header beginRefreshing];
        }
            break;
        default:{//日志
            self.type = 2;
            [self.tableView.mj_header beginRefreshing];
        }
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotificationObserver];
    [self createData];
    [self createNavUI];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)createData{
    self.type = -1;
    self.isNeedLoadHtml = YES;
    self.htmlHeight = 20.f;
    self.dataArray = [NSMutableArray new];
    self.view.backgroundColor = BaseColor;
}

- (void)createNavUI{
    WEAK_SELF
    if (!_navView) {
        _navView = [UIView new];
    }
    _navView.backgroundColor = [UIColor clearColor];
    
    if (!_navBottomView) {
        _navBottomView = [UIView new];
    }
    _navBottomView.backgroundColor = [UIColor clearColor];
    
    if (!_backBtn) {
        _backBtn = [UIButton new];
    }
    [_backBtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f)];
    _backBtn.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
    _backBtn.layer.cornerRadius = 16.f;
    _backBtn.layer.masksToBounds = YES;
    [_backBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
    }];
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.textColor = MainColor;
    _titleLab.font = FONT_B_36;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    if (!_addBtn) {
        _addBtn = [UIButton new];
    }
    [_addBtn setImage:[UIImage imageNamed:@"Release"] forState:UIControlStateNormal];
    [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f)];
    _addBtn.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
    _addBtn.layer.cornerRadius = 16.f;
    _addBtn.layer.masksToBounds = YES;
    _addBtn.hidden = !self.isEdit;
    [_addBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.userInfoModel.user.RIGHTS.integerValue == 2) {
            [weakSelf.popView show];
        }else{
            ECPostWorksViewController *postVC = [[ECPostWorksViewController alloc] init];
            postVC.isDesigner = NO;
            [WEAKSELF_BASENAVI pushViewController:postVC animated:YES titleLabel:@"创建文章"];
        }
    }];
    
    [self.view addSubview:_navView];
    [_navView addSubview:_navBottomView];
    [_navBottomView addSubview:_backBtn];
    [_navBottomView addSubview:_titleLab];
    [_navBottomView addSubview:_addBtn];
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(64.f);
    }];
    
    [_navBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
        make.centerY.mas_equalTo(weakSelf.navBottomView.mas_centerY);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.navBottomView.mas_centerX);
        make.height.mas_equalTo(44.f);
        make.bottom.mas_equalTo(0.f);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
        make.centerY.mas_equalTo(weakSelf.navBottomView.mas_centerY);
    }];
}

- (void)createUI{
    WEAK_SELF
    
    if (!_popView) {
        _popView = [[ECUserInfoAddPopView alloc] init];;
    }
    [self.view addSubview:_popView];
    [_popView setClickBlock:^(NSInteger index) {
        if (index == 0) {
            ECPostWorksViewController *postVC = [[ECPostWorksViewController alloc] init];
            postVC.isDesigner = YES;
            [WEAKSELF_BASENAVI pushViewController:postVC animated:YES titleLabel:@"创建案例"];
        }else{
            ECPostLogsViewController *postVC = [[ECPostLogsViewController alloc] init];
            [WEAKSELF_BASENAVI pushViewController:postVC animated:YES titleLabel:@"发表日志"];
        }
    }];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        switch (weakSelf.type) {
            case -1:
            case 0:{
                [weakSelf requestUserInfo];
            }
                break;
            case 1:
            case 4:{
                weakSelf.pageIndex = 1;
                [weakSelf requestArticle];
            }
                break;
            case 2:{
                weakSelf.pageIndex = 1;
                [weakSelf requestLogsList];
            }
                break;
            default:{
                weakSelf.pageIndex = 1;
                [weakSelf requestCommentList];
            }
                break;
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        switch (weakSelf.type) {
            case 0:{
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
                break;
            case 1:
            case 4:{
                weakSelf.pageIndex ++;
                [weakSelf requestArticle];
            }
                break;
            case 2:{
                weakSelf.pageIndex ++;
                [weakSelf requestLogsList];
            }
                break;
            default:{
                weakSelf.pageIndex ++;
                [weakSelf requestCommentList];
            }
                break;
        }
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(-20.f);
    }];

    [self.tableView.mj_header beginRefreshing];
}

- (void)updateTableOffset{
    WEAK_SELF
    if ([[Keychain objectForKey:EC_USER_ID] isEqualToString:self.userid]) {//如果是看自己
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0.f);
            make.top.mas_equalTo(-20.f);
        }];
    }else{
        if (!_bottomView) {
            _bottomView = [UIView new];
        }
        _bottomView.backgroundColor = LineDefaultsColor;
        
        if (!_orderBtn) {
            _orderBtn = [UIButton new];
        }
        [_orderBtn setTitle:@"下订单" forState:UIControlStateNormal];
        [_orderBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
        _orderBtn.titleLabel.font = FONT_32;
        _orderBtn.backgroundColor = [UIColor whiteColor];
        [_orderBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            if (EC_USER_WHETHERLOGIN) {
                ECPlaceOrderModel *orderModel = [[ECPlaceOrderModel alloc] init];
                orderModel.designer_id = weakSelf.userInfoModel.designerinfo.designer_id;
                
                ECPlaceOrderViewController *placeOrderVC = [[ECPlaceOrderViewController alloc] init];
                placeOrderVC.orderModel = orderModel;
                placeOrderVC.designerName = weakSelf.userInfoModel.designerinfo.name;
                placeOrderVC.designerTitleImage = weakSelf.userInfoModel.designerinfo.desigerHeadImg;
                placeOrderVC.isUpdate = NO;
                [WEAKSELF_BASENAVI pushViewController:placeOrderVC animated:YES titleLabel:@"下单"];
            }else{
                [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
                }];
            }
        }];
        
        if (!_chatBtn) {
            _chatBtn = [UIButton new];
        }
        [_chatBtn setTitle:@"联系TA" forState:UIControlStateNormal];
        [_chatBtn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = FONT_32;
        _chatBtn.backgroundColor = [UIColor whiteColor];
        [_chatBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            if (EC_USER_WHETHERLOGIN) {
                ECChatListModel *chatModel = [[ECChatListModel alloc] init];
                chatModel.firendIds = weakSelf.userInfoModel.designerinfo.userid;
                chatModel.name = weakSelf.userInfoModel.designerinfo.name;
                chatModel.headImage = weakSelf.userInfoModel.designerinfo.desigerHeadImg;
                ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:weakSelf.userInfoModel.designerinfo.userid conversationType:EMConversationTypeChat];
                vc.chatListModel = chatModel;
                [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:weakSelf.userInfoModel.designerinfo.name];
            }else{
                [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
                }];
            }
        }];
        
        if (!_focusBtn) {
            _focusBtn = [UIButton new];
        }
        [_focusBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_focusBtn setTitle:@"已关注" forState:UIControlStateSelected];
        _focusBtn.selected = [self.userInfoModel.user.ATTENTION isEqualToString:@"1"];
        [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _focusBtn.titleLabel.font = FONT_32;
        _focusBtn.backgroundColor = [UIColor blackColor];
        [_focusBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
            if (EC_USER_WHETHERLOGIN) {
                [weakSelf requestFocus];
            }else{
                [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
                }];
            }
        }];
        
        [self.view addSubview:_bottomView];
        [_bottomView addSubview:_orderBtn];
        [_bottomView addSubview:_chatBtn];
        [_bottomView addSubview:_focusBtn];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.f);
            make.top.mas_equalTo(-20.f);
            make.bottom.mas_equalTo(-49.f);
        }];
        
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0.f);
            make.top.mas_equalTo(weakSelf.tableView.mas_bottom);
        }];
        
        if ([[USERDEFAULT objectForKey:EC_USER_STATUS] isEqualToString:@"2"]){//如果自己为设计师
            _orderBtn.hidden = YES;
            
            [_chatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.mas_equalTo(0.f);
                make.right.mas_equalTo(weakSelf.focusBtn.mas_left).offset(-0.5f);
                make.width.mas_equalTo(weakSelf.focusBtn.mas_width);
            }];
            
            [_focusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.mas_equalTo(0.f);
                make.left.mas_equalTo(weakSelf.chatBtn.mas_right).offset(0.5f);
                make.width.mas_equalTo(weakSelf.chatBtn.mas_width);
            }];
        }else{
            [_orderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(0.f);
                make.top.mas_equalTo(0.5f);
                make.width.mas_equalTo(SCREENWIDTH * (175.f / 750.f));
            }];
            
            [_chatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.orderBtn.mas_right).offset(0.5f);
                make.top.bottom.width.equalTo(weakSelf.orderBtn);
            }];
            
            [_focusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.mas_equalTo(0.f);
                make.left.mas_equalTo(weakSelf.chatBtn.mas_right);
            }];
        }
    }
}

- (void)requestUserInfo{
    WEAK_SELF
    [ECHTTPServer requestGetUserInfoWithUserID:[[Keychain objectForKey:EC_USER_ID] isEqualToString:self.userid] ? @"" : self.userid succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            weakSelf.userInfoModel = [ECUserInfoModel yy_modelWithDictionary:result];
            weakSelf.type = weakSelf.userInfoModel.user.RIGHTS.integerValue == 2 ? 0 : 4;
            [weakSelf updateTableOffset];
            if (weakSelf.type == 4) {
                weakSelf.pageIndex = 1;
                [weakSelf requestArticle];
            }else{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            [weakSelf.tableView.mj_header endRefreshing];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)requestArticle{
    WEAK_SELF
    [ECHTTPServer requestArticleListWithUserID:self.userid WithPageIndex:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"articleCaseList"]) {
                [weakSelf.dataArray addObject:[ECWorksModel yy_modelWithDictionary:dict]];
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

- (void)requestLogsList{
    WEAK_SELF
    [ECHTTPServer requestLogsListWithUserID:self.userid WithPageIndex:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"logList"]) {
                [weakSelf.dataArray addObject:[ECLogsModel yy_modelWithDictionary:dict]];
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

- (void)requestCommentList{
    WEAK_SELF
    [ECHTTPServer requestUserInfoCommentListWithUserID:self.userid WithPageIndex:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"userCommentList"]) {
                [weakSelf.dataArray addObject:[ECUserInfoCommentModel yy_modelWithDictionary:dict]];
            }
            weakSelf.commentScore = result[@"star_level"];
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

- (void)requestFocus{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestFocusAndFansFocusWithUserID:self.userid succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            if ([weakSelf.userInfoModel.user.ATTENTION isEqualToString:@"1"] || weakSelf.userInfoModel.user.ATTENTION.length == 0) {
                weakSelf.userInfoModel.user.ATTENTION = @"0";
            }else{
                weakSelf.userInfoModel.user.ATTENTION = @"1";
            }
            weakSelf.focusBtn.selected = [weakSelf.userInfoModel.user.ATTENTION isEqualToString:@"1"];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestDeleteUserWorks:(NSString *)worksID WithRow:(NSInteger)row{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestDeleteUserWorksWithID:worksID succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            [weakSelf.dataArray removeObjectAtIndex:row - 2];
            [weakSelf.tableView reloadData];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestDeleteUserLogs:(NSString *)logsID WithRow:(NSInteger)row{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestDeleteUserLogsWithID:logsID succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            [weakSelf.dataArray removeObjectAtIndex:row - 2];
            [weakSelf.tableView reloadData];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.type) {
        case 0:{
            return 5;
        }
            break;
        case 1:
        case 2:
        case 4:{
            return 2 + self.dataArray.count;
        }
            break;
        case 3:{
            if (self.dataArray.count == 0) {
                return 2;
            }else{
                return 3 + self.dataArray.count;
            }
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.row) {
        case 0:{
            ECUserInfoHeaderTableViewCell *cell = [ECUserInfoHeaderTableViewCell cellWithTableView:tableView];
            cell.model = self.userInfoModel;
            cell.isEdit = self.isEdit;
            [cell setTypeClickBlock:^(NSInteger type) {
                if (type == 2) {
                    weakSelf.type = weakSelf.userInfoModel.user.RIGHTS.integerValue == 2 ? 1 : 4;
                    [weakSelf.tableView.mj_header beginRefreshing];
                }else{
                    ECFocusAndFansViewController *focusAndFansVC = [[ECFocusAndFansViewController alloc] init];
                    focusAndFansVC.type = type;
                    focusAndFansVC.userID = weakSelf.userid;
                    [WEAKSELF_BASENAVI pushViewController:focusAndFansVC animated:YES titleLabel:@"关注与粉丝"];
                }
            }];
            [cell setEditInfoBlock:^{
                ECUserInfoEditViewController *userInfoVC = [[ECUserInfoEditViewController alloc] init];
                [WEAKSELF_BASENAVI pushViewController:userInfoVC animated:YES titleLabel:@"修改资料"];
            }];
            return cell;
        }
            break;
        case 1:{
            ECUserInfoTypeTableViewCell *cell = [ECUserInfoTypeTableViewCell cellWithTableView:tableView];
            cell.isDesigner = self.userInfoModel.user.RIGHTS.integerValue == 2;
            cell.type = self.type;
            [cell setTypeClickBlock:^(NSInteger type) {
                weakSelf.type = type;
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
            return cell;
        }
            break;
        default:{
            switch (self.type) {
                case 0:{
                    switch (indexPath.row) {
                        case 2:{
                            ECUserInfomationTableViewCell *cell = [ECUserInfomationTableViewCell cellWithTableView:tableView];
                            cell.model = self.userInfoModel;
                            return cell;
                        }
                            break;
                        case 3:{
                            ECUserInfoDesignerResumeTableViewCell *cell = [ECUserInfoDesignerResumeTableViewCell cellWithTableView:tableView];
                            [cell loadHtmlWithConntent:self.userInfoModel.designerinfo.resumeUrl WithNeed:self.isNeedLoadHtml];
                            [cell setLoadHtmlHeightBlock:^(CGFloat height) {
                                weakSelf.isNeedLoadHtml = NO;
                                weakSelf.htmlHeight = height;
                                [weakSelf.tableView reloadData];
                            }];
                            return cell;
                        }
                            break;
                        default:{
                            ECUserInfoDesignerExpressTableViewCell *cell = [ECUserInfoDesignerExpressTableViewCell cellWithTableView:tableView];
                            cell.content = self.userInfoModel.designerinfo.experience;
                            return cell;
                        }
                            break;
                    }
                }
                    break;
                case 1:
                case 4:{
                    ECWorksTableViewCell *cell = [ECWorksTableViewCell cellWithTableView:tableView];
                    cell.model = self.dataArray[indexPath.row - 2];
                    cell.isUserDelete = [[Keychain objectForKey:EC_USER_ID] isEqualToString:self.userid];
                    [cell setDeleteUserBlock:^(NSString *worksID, NSInteger row) {
                        [weakSelf requestDeleteUserWorks:worksID WithRow:row];
                    }];
                    return cell;
                }
                    break;
                case 2:{
                    ECLogsTableViewCell *cell = [ECLogsTableViewCell cellWithTableView:tableView];
                    cell.model = self.dataArray[indexPath.row - 2];
                    cell.isUserDelete = [[Keychain objectForKey:EC_USER_ID] isEqualToString:self.userid];
                    [cell setDeleteUserBlock:^(NSString *logsID, NSInteger row) {
                        [weakSelf requestDeleteUserLogs:logsID WithRow:row];
                    }];
                    return cell;
                }
                    break;
                case 3:{
                    switch (indexPath.row) {
                        case 2:{
                            ECUserInfoEvaluationStartTableViewCell *cell = [ECUserInfoEvaluationStartTableViewCell cellWithTableView:tableView];
                            cell.score = self.commentScore;
                            return cell;
                        }
                            break;
                        default:{
                            ECUserInfoEvaluationCommentTableViewCell *cell = [ECUserInfoEvaluationCommentTableViewCell cellWithTableView:tableView];
                            cell.model = self.dataArray[indexPath.row - 3];
                            return cell;
                        }
                            break;
                    }
                    return nil;
                }
                    break;
                default:{
                    return nil;
                }
                    break;
            }
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return SCREENWIDTH * (512.f / 750.f);
        }
            break;
        case 1:{
            return 44.f;
        }
            break;
        default:{
            switch (self.type) {
                case 0:{
                    switch (indexPath.row) {
                        case 2:{
                            return 269.f;
                        }
                            break;
                        case 3:{
                            return self.htmlHeight + 78.f;
                        }
                            break;
                        default:{
                            return 90.f + [CMPublicMethod getHeightWithContent:self.userInfoModel.designerinfo.experience width:(SCREENWIDTH - 24.f) font:16.f];
                        }
                            break;
                    }
                }
                    break;
                case 1:
                case 4:{
                    return 101.f + SCREENWIDTH * (350.f / 750.f);
                }
                    break;
                case 2:{
                    ECLogsModel *model = self.dataArray[indexPath.row - 2];
                    CGFloat height = 75.f + [CMPublicMethod getHeightWithContent:model.title width:(SCREENWIDTH - 24.f) font:16.f];
                    if (model.imgurl.count == 0) {
                        return height;
                    }
                    height += 12.f;
                    height += ceill(model.imgurl.count / 3.f) * ((SCREENWIDTH - 44.f) / 3.f * (144.f / 220.f));
                    height += (ceil(model.imgurl.count / 3.f) - 1) * 10.f;
                    return height;
                }
                    break;
                case 3:{
                    switch (indexPath.row) {
                        case 2:{
                            return 60.f;
                        }
                            break;
                        default:{
                            ECUserInfoCommentModel *model = self.dataArray[indexPath.row - 3];
                            CGFloat height = [CMPublicMethod getHeightWithContent:model.comment width:(SCREENWIDTH - 24.f) font:16.f] + 104.f;
                            if (model.imgurls.count != 0) {
                                height += 88.f;
                            }
                            return height;
                        }
                            break;
                    }
                    return 0.f;
                }
                    break;
                default:{
                    return 0.f;
                }
                    break;
            }
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
        }
            break;
        case 1:{
        }
            break;
        default:{
            switch (self.type) {
                case 0:{
                }
                    break;
                case 1:
                case 4:{
                    ECWorksModel *model = self.dataArray[indexPath.row - 2];
                    ECWorksDetailViewController *worksDetailVC = [[ECWorksDetailViewController alloc] init];
                    worksDetailVC.worksID = model.worksID;
                    [SELF_BASENAVI pushViewController:worksDetailVC animated:YES titleLabel:@"详情"];
                }
                    break;
                case 2:{
                }
                    break;
                case 3:{
                }
                    break;
                default:{
                }
                    break;
            }
        }
            break;
    }
}

@end
