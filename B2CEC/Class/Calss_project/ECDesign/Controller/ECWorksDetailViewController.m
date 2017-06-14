//
//  ECWorksDetailViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWorksDetailViewController.h"
#import "ECWorksDetailUserInfoTableViewCell.h"
#import "ECNewsInfoHtmlTableViewCell.h"
#import "ECNewsInfoLikeTableViewCell.h"
#import "ECNewsInputCommentView.h"

#import "ECWorksModel.h"

#import "ECDesignerCommentViewController.h"
#import "ECReportViewController.h"

@interface ECWorksDetailViewController ()

@property (strong,nonatomic) UIView *navView;

@property (strong,nonatomic) UIView *navBottomView;

@property (strong,nonatomic) UIButton *backBtn;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIButton *focusBtn;

@property (strong,nonatomic) ECWorksDetailModel *worksModel;

@property (assign,nonatomic) CGFloat htmlHeight;

@property (assign,nonatomic) BOOL isNeedLoadHtml;

@property (strong,nonatomic) ECNewsInputCommentView *inputView;

@end

@implementation ECWorksDetailViewController

- (void)addNotificationObserver{
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestWorksDetail), NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestWorksDetail), NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)dealloc{
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotificationObserver];
    [self createData];
    [self createNavUI];
    [self createUI];
    showLoadingGif(self.view)
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
    _htmlHeight = 0.f;
    _isNeedLoadHtml = YES;
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
    
    if (!_focusBtn) {
        _focusBtn = [UIButton new];
    }
    [_focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_focusBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [_focusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_focusBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (EC_USER_WHETHERLOGIN) {
            [weakSelf requestFocusClick];
        }else{
            [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
            }];
        }
    }];
    
    [self.view addSubview:_navView];
    [_navView addSubview:_navBottomView];
    [_navBottomView addSubview:_backBtn];
    [_navBottomView addSubview:_titleLab];
    [_navBottomView addSubview:_focusBtn];
    
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
    
    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.size.mas_equalTo(CGSizeMake(60.f, 44.f));
        make.centerY.mas_equalTo(weakSelf.navBottomView.mas_centerY);
    }];
}

- (void)createUI{
    WEAK_SELF
    
    if (!_inputView) {
        _inputView = [ECNewsInputCommentView new];
    }
    _inputView.isInput = NO;
    _inputView.isStyleBlack = NO;
    _inputView.hidden = YES;
    [_inputView setInputClickBlock:^{
        if (EC_USER_WHETHERLOGIN) {
            [weakSelf gotoCommentVC:YES];
        }else{
            [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
            }];
        }
    }];
    [_inputView setCommentClickBlock:^{
        [weakSelf gotoCommentVC:NO];
    }];
    [_inputView setCollecClickBlock:^{
        if (EC_USER_WHETHERLOGIN) {
            [weakSelf requestWorksCollect];
        }else{
            [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
            }];
        }
    }];
    [_inputView setShareClickBlock:^{
        [CMPublicMethod shareToPlatformWithTitle:weakSelf.worksModel.title WithLink:[NSString stringWithFormat:@"%@id=%@",[CMPublicDataManager sharedCMPublicDataManager].publicDataModel.caseShareUrl,weakSelf.worksID] WithQCode:NO];
    }];
    
    [self.view addSubview:_inputView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestWorksDetail];
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(-20.f);
        make.bottom.mas_equalTo(-49.f);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.tableView.mas_bottom);
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestWorksDetail{
    WEAK_SELF
    [ECHTTPServer requestWorksDetailWithWorksID:self.worksID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            weakSelf.worksModel = [ECWorksDetailModel yy_modelWithDictionary:result[@"articleCaseInfo"]];
            weakSelf.focusBtn.selected = [weakSelf.worksModel.user.ATTENTION isEqualToString:@"1"];
            weakSelf.focusBtn.hidden = [weakSelf.worksModel.user.USER_ID isEqualToString:[Keychain objectForKey:EC_USER_ID]];
            [weakSelf.tableView reloadData];
            
            weakSelf.inputView.commentCount = weakSelf.worksModel.comment;
            weakSelf.inputView.isCollect = weakSelf.worksModel.iscollect;
            
            weakSelf.inputView.hidden = NO;
            NSLog(@"%@",result);
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)requestFocusClick{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestFocusAndFansFocusWithUserID:self.worksModel.user.USER_ID succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            if ([weakSelf.worksModel.user.ATTENTION isEqualToString:@"1"] || weakSelf.worksModel.user.ATTENTION.length == 0) {
                weakSelf.worksModel.user.ATTENTION = @"0";
                weakSelf.focusBtn.selected = NO;
            }else{
                weakSelf.worksModel.user.ATTENTION = @"1";
                weakSelf.focusBtn.selected = YES;
            }
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestWorksPraise:(BOOL)isPraise{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestWorksPraiseWithType:isPraise ? @"1" : @"2" WithWorksID:self.worksID succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            if (isPraise) {
                weakSelf.worksModel.praiseType = @"1";
                weakSelf.worksModel.praise = [NSString stringWithFormat:@"%ld",weakSelf.worksModel.praise.integerValue + 1];
            }else{
                weakSelf.worksModel.praiseType = @"2";
                weakSelf.worksModel.Boo = [NSString stringWithFormat:@"%ld",weakSelf.worksModel.Boo.integerValue + 1];
            }
            [weakSelf.tableView reloadData];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestWorksCollect{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestWorksCollectWithWorksID:self.worksID succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if ([weakSelf.worksModel.iscollect isEqualToString:@"0"]) {
                weakSelf.worksModel.iscollect = @"1";
                weakSelf.inputView.isCollect = weakSelf.worksModel.iscollect;
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }else{
                weakSelf.worksModel.iscollect = @"0";
                weakSelf.inputView.isCollect = weakSelf.worksModel.iscollect;
                [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            }
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)gotoCommentVC:(BOOL)isEdit{
    if ([[Keychain objectForKey:EC_USER_ID] isEqualToString:_worksModel.user_id]) {
        [SVProgressHUD showInfoWithStatus:@"不能评论自己的文章或者案例哦"];
        return;
    }
    WEAK_SELF
    ECDesignerCommentViewController *worksCommentVC = [[ECDesignerCommentViewController alloc] init];
    worksCommentVC.isEdit = isEdit;
    worksCommentVC.worksID = self.worksID;
    [SELF_BASENAVI pushViewController:worksCommentVC animated:YES titleLabel:@"用户评论"];
    [worksCommentVC setSendCommentTextBlock:^{
        weakSelf.worksModel.comment = [NSString stringWithFormat:@"%ld",weakSelf.worksModel.comment.integerValue + 1];
        weakSelf.inputView.commentCount = weakSelf.worksModel.comment;
    }];
}

- (void)requestReportWithType:(NSString *)type WithContent:(NSString *)content{
    SHOWSVP
    [ECHTTPServer requestReportWithType:2 WithID:self.worksID WithContent:content WithCategory:type succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            [SVProgressHUD showSuccessWithStatus:@"您已举报该内容，感谢您的反馈，我们会尽快处理!"];
        }else{
            RequestSuccess(result);
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.row) {
        case 0:{
            ECWorksDetailUserInfoTableViewCell *cell = [ECWorksDetailUserInfoTableViewCell cellWithTableView:tableView];
            cell.model = self.worksModel;
            return cell;
        }
            break;
        case 1:{
            ECNewsInfoHtmlTableViewCell *cell = [ECNewsInfoHtmlTableViewCell cellWithTableView:tableView];
            [cell loadHtmlWithConntent:self.worksModel.content WithNeed:self.isNeedLoadHtml];
            [cell setLoadHtmlHeightBlock:^(CGFloat htmlHeight) {
                weakSelf.isNeedLoadHtml = NO;
                weakSelf.htmlHeight = htmlHeight;
                [weakSelf.tableView reloadData];
                dismisLoadingGif(weakSelf.view)
                weakSelf.navigationController.navigationBarHidden = YES;
            }];
            return cell;
        }
            break;
        case 2:{
            ECNewsInfoLikeTableViewCell *cell = [ECNewsInfoLikeTableViewCell cellWithTableView:tableView];
            cell.praiseType = self.worksModel.praiseType;
            cell.praise = self.worksModel.praise;
            cell.boo = self.worksModel.Boo;
            [cell setPraiseClickBlock:^(BOOL isPraise) {
                if (EC_USER_WHETHERLOGIN) {
                    [weakSelf requestWorksPraise:isPraise];
                }else{
                    [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
                    }];
                }
            }];
            [cell setReportClickBlock:^{
                [ECReportViewController showReportVCInSuperViewController:weakSelf verifyResultBlock:^(NSString *type, NSString *content) {
                    [weakSelf requestReportWithType:type WithContent:content];
                }];
            }];
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
    switch (indexPath.row) {
        case 0:{
            if (self.worksModel.style.length == 0) {
                return SCREENWIDTH * (350.f / 750.f) + [CMPublicMethod getHeightWithContent:self.worksModel.title width:(SCREENWIDTH - 24.f) font:21.f] + 177.f - 49.f;
            }else{
                return SCREENWIDTH * (350.f / 750.f) + [CMPublicMethod getHeightWithContent:self.worksModel.title width:(SCREENWIDTH - 24.f) font:21.f] + 177.f;
            }
        }
            break;
        case 1:{
            return _htmlHeight;
        }
            break;
        case 2:{
            return 62.f;
        }
            break;
        default:{
            return 0.f;
        }
            break;
    }
}

@end
