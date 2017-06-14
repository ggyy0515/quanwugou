//
//  ECNewsInfoViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsInfoViewController.h"
#import "ECNewsInfoHeadTableViewCell.h"
#import "ECNewsInfoHtmlTableViewCell.h"
#import "ECNewsInfoLikeTableViewCell.h"
#import "ECNewsInfoTitleTableViewCell.h"
#import "ECNewsInfoRelatedTableViewCell.h"
#import "ECHomeAdvertisingTableViewCell.h"
#import "ECNewsInputCommentView.h"
#import "ECNewsCommentModel.h"
#import "ECNewsInfoCommentTableViewCell.h"

#import "ECNewsVideoInfoViewController.h"
#import "ECNewsBigImageViewViewController.h"
#import "ECAdvertisingViewController.h"
#import "ECUserInfoViewController.h"
#import "ECReportViewController.h"

@interface ECNewsInfoViewController ()

@property (strong,nonatomic) NSMutableArray *recommendArray;

@property (strong,nonatomic) NSDictionary *adverDict;

@property (strong,nonatomic) ECNewsInfomationModel *infomationModel;

@property (assign,nonatomic) NSInteger pageIndex;

@property (strong,nonatomic) NSMutableArray *commentArray;

@property (strong,nonatomic) ECNewsInputCommentView *inputView;

@property (assign,nonatomic) CGFloat htmlHeight;

@property (assign,nonatomic) BOOL isNeedLoadHtml;

@end

@implementation ECNewsInfoViewController

- (void)addNotificationObserver{
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestNewsInfo), NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestNewsInfo), NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)dealloc{
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotificationObserver];
    [self createData];
    [self createUI];
    [self requestNewsInfo];
}

- (void)createData{
    _pageIndex = 1;
    _htmlHeight = 0.f;
    _isNeedLoadHtml = YES;
    _recommendArray = [NSMutableArray new];
    _commentArray = [NSMutableArray new];
    _adverDict = [NSDictionary dictionary];
}

- (void)createUI{
    WEAK_SELF
    if (!_inputView) {
        _inputView = [ECNewsInputCommentView new];
    }
    _inputView.isInput = YES;
    _inputView.isStyleBlack = NO;
    _inputView.hidden = YES;
    [_inputView setInputClickBlock:^{
        if (!EC_USER_WHETHERLOGIN) {
            [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
            }];
        }
    }];
    [_inputView setCommentClickBlock:^{
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 + weakSelf.recommendArray.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    [_inputView setCollecClickBlock:^{
        if (EC_USER_WHETHERLOGIN) {
            [weakSelf requestNewsCollect];
        }else{
            [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
            }];
        }
    }];
    [_inputView setShareClickBlock:^{
        [CMPublicMethod shareToPlatformWithTitle:weakSelf.infomationModel.title WithLink:[NSString stringWithFormat:@"%@BIANMA=%@&informationId=%@",[CMPublicDataManager sharedCMPublicDataManager].publicDataModel.informationShareUrl,weakSelf.BIANMA,weakSelf.informationId] WithQCode:NO];
    }];
    [_inputView setSendCommentTextBlock:^(NSString *comment) {
        [weakSelf requestNewsSendCommentWithComment:comment];
    }];
    
    [self.view addSubview:_inputView];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestNewsComment:NO];
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.bottom.mas_equalTo(-49.f);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.tableView.mas_bottom);
    }];
}

- (void)requestNewsInfo{
    showLoadingGif(self.view)
    WEAK_SELF
    [ECHTTPServer requestNewsInfoWithBianma:self.BIANMA WithNewsID:self.informationId succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            weakSelf.infomationModel = [ECNewsInfomationModel yy_modelWithDictionary:result[@"information"]];
            for (NSDictionary *dict in result[@"recommendList"]) {
                ECNewsRecommendModel *model = [ECNewsRecommendModel yy_modelWithDictionary:dict];
                [weakSelf.recommendArray addObject:model];
            }
            weakSelf.adverDict = result[@"ad"];
            
            weakSelf.inputView.commentCount = weakSelf.infomationModel.commentNum;
            weakSelf.inputView.isCollect = weakSelf.infomationModel.iscollect;
            
            weakSelf.inputView.hidden = NO;
            //请求评论内容
            [weakSelf requestNewsComment:NO];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestNewsComment:(BOOL)isScro{
    WEAK_SELF
    [ECHTTPServer requestNewsCommentWithNewsID:self.informationId WithPageIndex:self.pageIndex succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            if (weakSelf.pageIndex == 1) {
                [weakSelf.commentArray removeAllObjects];
            }
            for (NSDictionary *dict in result[@"commentList"]) {
                ECNewsCommentModel *model = [ECNewsCommentModel yy_modelWithDictionary:dict];
                [weakSelf.commentArray addObject:model];
            }
            
            weakSelf.infomationModel.commentNum = result[@"commentNum"];
            
            [weakSelf.tableView reloadData];
            
            if (isScro) {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 + weakSelf.recommendArray.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
            if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.pageIndex) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            RequestError
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestNewsPraise:(BOOL)isPraise{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestNewsPraiseWithType:isPraise ? @"1" : @"2" WithNewsID:self.informationId succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            if (isPraise) {
                weakSelf.infomationModel.praiseType = @"1";
                weakSelf.infomationModel.praise = [NSString stringWithFormat:@"%ld",weakSelf.infomationModel.praise.integerValue + 1];
            }else{
                weakSelf.infomationModel.praiseType = @"2";
                weakSelf.infomationModel.Boo = [NSString stringWithFormat:@"%ld",weakSelf.infomationModel.Boo.integerValue + 1];
            }
            [weakSelf.tableView reloadData];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestNewsCollect{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestNewsCollectWithNewsID:self.informationId succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if ([weakSelf.infomationModel.iscollect isEqualToString:@"0"]) {
                weakSelf.infomationModel.iscollect = @"1";
                weakSelf.inputView.isCollect = weakSelf.infomationModel.iscollect;
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }else{
                weakSelf.infomationModel.iscollect = @"0";
                weakSelf.inputView.isCollect = weakSelf.infomationModel.iscollect;
                [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            }
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestNewsSendCommentWithComment:(NSString *)comment{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestNewsSendCommentWithNewsID:self.informationId WithComment:comment succeed:^(NSURLSessionDataTask *task, id result) {
        RequestSuccess(result);
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.sendCommentTextBlock) {
                weakSelf.sendCommentTextBlock();
            }
            weakSelf.pageIndex = 1;
            [weakSelf requestNewsComment:YES];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestFocusNews{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestFocusNewsWithNewsID:self.informationId succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if ([weakSelf.infomationModel.isattention isEqualToString:@"0"]) {
                weakSelf.infomationModel.isattention = @"1";
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            }else{
                weakSelf.infomationModel.isattention = @"0";
                [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            }
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestReportWithType:(NSString *)type WithContent:(NSString *)content{
    SHOWSVP
    [ECHTTPServer requestReportWithType:1 WithID:self.informationId WithContent:content WithCategory:type succeed:^(NSURLSessionDataTask *task, id result) {
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
    if (self.recommendArray.count == 0) {
        return 0;
    }
    return 7 + self.recommendArray.count + self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.row) {
        case 0:{
            ECNewsInfoHeadTableViewCell *cell = [ECNewsInfoHeadTableViewCell cellWithTableView:tableView];
            cell.model = self.infomationModel;
            [cell setFocusClickBlock:^(BOOL isFocus) {
                if (EC_USER_WHETHERLOGIN) {
                    [weakSelf requestFocusNews];
                }else{
                    [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
                    }];
                }
            }];
            return cell;
        }
            break;
        case 1:{
            ECNewsInfoHtmlTableViewCell *cell = [ECNewsInfoHtmlTableViewCell cellWithTableView:tableView];
            [cell loadHtmlWithConntent:self.infomationModel.getContentUrl WithNeed:self.isNeedLoadHtml];
            [cell setLoadHtmlHeightBlock:^(CGFloat htmlHeight) {
                dismisLoadingGif(weakSelf.view)
                weakSelf.isNeedLoadHtml = NO;
                weakSelf.htmlHeight = htmlHeight;
                [weakSelf.tableView reloadData];
            }];
            return cell;
        }
            break;
        case 2:{
            ECNewsInfoLikeTableViewCell *cell = [ECNewsInfoLikeTableViewCell cellWithTableView:tableView];
            cell.praiseType = self.infomationModel.praiseType;
            cell.praise = self.infomationModel.praise;
            cell.boo = self.infomationModel.Boo;
            [cell setPraiseClickBlock:^(BOOL isPraise) {
                if (EC_USER_WHETHERLOGIN) {
                    [weakSelf requestNewsPraise:isPraise];
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
        case 3:{
            ECNewsInfoTitleTableViewCell *cell = [ECNewsInfoTitleTableViewCell cellWithTableView:tableView];
            cell.isHiddenTitle = NO;
            cell.title = @"相关资讯";
            return cell;
        }
            break;
        default:{
            if (indexPath.row > 3 && indexPath.row < (self.recommendArray.count + 4)) {
                ECNewsInfoRelatedTableViewCell *cell = [ECNewsInfoRelatedTableViewCell cellWithTableView:tableView];
                cell.model = self.recommendArray[indexPath.row - 4];
                return cell;
            }else if (indexPath.row == (4 + self.recommendArray.count)){
                ECNewsInfoTitleTableViewCell *cell = [ECNewsInfoTitleTableViewCell cellWithTableView:tableView];
                cell.isHiddenTitle = YES;
                return cell;
            }else if (indexPath.row == (5 + self.recommendArray.count)){
                ECHomeAdvertisingTableViewCell *cell = [ECHomeAdvertisingTableViewCell cellWithTableView:tableView];
                cell.imageUrl = self.adverDict[@"cover1"];
                cell.title = self.adverDict[@"title"];
                cell.backgroundColor = [UIColor whiteColor];
                return cell;
            }else if (indexPath.row == (6 + self.recommendArray.count)){
                ECNewsInfoTitleTableViewCell *cell = [ECNewsInfoTitleTableViewCell cellWithTableView:tableView];
                cell.isHiddenTitle = NO;
                cell.title = [NSString stringWithFormat:@"用户评论(%@)",self.infomationModel.commentNum];
                return cell;
            }else{
                ECNewsInfoCommentTableViewCell *cell = [ECNewsInfoCommentTableViewCell cellWithTableView:tableView];
                ECNewsCommentModel *mode = self.commentArray[indexPath.row - 7 - self.recommendArray.count];
                cell.title_img = mode.title_img;
                cell.name = mode.name;
                cell.edittime = mode.edittime;
                cell.content = mode.content;
                cell.userID = mode.user_id;
                [cell setIconClickBlock:^(NSString *userID) {
                    ECUserInfoViewController *userInfoVC = [[ECUserInfoViewController alloc] init];
                    userInfoVC.userid = userID;
                    userInfoVC.isEdit = NO;
                    [WEAKSELF_BASENAVI pushViewController:userInfoVC animated:YES titleLabel:@"个人信息"];
                }];
                return cell;
            }
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return [self.infomationModel.title boundingRectWithSize:CGSizeMake(SCREENWIDTH - 36.f, 1000999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:24.f]} context:nil].size.height + 94.f;
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
        case 3:{
            return 44.f;
        }
            break;
        default:{
            if (indexPath.row > 3 && indexPath.row < (self.recommendArray.count + 4)) {
                return 50.f;
            }else if (indexPath.row == (4 + self.recommendArray.count)){
                return 8.f;
            }else if (indexPath.row == (5 + self.recommendArray.count)){
                return 64.f + (SCREENWIDTH - 36.f) * (190.f / 678.f);
            }else if (indexPath.row == (6 + self.recommendArray.count)){
                return 44.f;
            }else{
                ECNewsCommentModel *mode = self.commentArray[indexPath.row - 7 - self.recommendArray.count];
                return [CMPublicMethod getHeightWithContent:mode.content width:(SCREENWIDTH - 66.f) font:16.f] + 104.f;
            }
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 3 && indexPath.row < (self.recommendArray.count + 4)) {
        ECNewsRecommendModel *model = self.recommendArray[indexPath.row - 4];
        switch (model.type.integerValue) {
            case 0:{//单图、多图、无图
                ECNewsInfoViewController *newsInfoVC = [[ECNewsInfoViewController alloc] init];
                newsInfoVC.BIANMA = model.classify;
                newsInfoVC.informationId = model.newsID;
                [SELF_BASENAVI pushViewController:newsInfoVC animated:YES titleLabel:model.resource];
            }
                break;
            case 1:{//大图
                ECNewsBigImageViewViewController *newsBigImageVC = [[ECNewsBigImageViewViewController alloc] init];
                newsBigImageVC.BIANMA = model.classify;
                newsBigImageVC.informationId = model.newsID;
                [SELF_BASENAVI pushViewController:newsBigImageVC animated:YES titleLabel:model.resource];
            }
                break;
            case 2:{//视频
                ECNewsVideoInfoViewController *videoInfoVC = [[ECNewsVideoInfoViewController alloc] init];
                videoInfoVC.BIANMA = model.classify;
                videoInfoVC.informationId = model.newsID;
                [SELF_BASENAVI pushViewController:videoInfoVC animated:YES titleLabel:model.resource];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.row == (5 + self.recommendArray.count)){
        ECAdvertisingViewController *advertisingVC = [[ECAdvertisingViewController alloc] init];
        advertisingVC.url = self.adverDict[@"weburl"];
        advertisingVC.isHavRightNav = NO;
        [SELF_BASENAVI pushViewController:advertisingVC animated:YES titleLabel:self.adverDict[@"title"]];
    }
}
@end
