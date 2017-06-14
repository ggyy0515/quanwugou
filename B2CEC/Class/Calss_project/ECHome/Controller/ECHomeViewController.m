//
//  ECHomeViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHomeViewController.h"
#import "ECHomeOptionsView.h"
#import "ECHomeSingleImageTableViewCell.h"
#import "ECHomeMoreImageTableViewCell.h"
#import "ECHomeNoneImageTableViewCell.h"
#import "ECHomeBigImageTableViewCell.h"
#import "ECHomeAdvertisingTableViewCell.h"
#import "ECHomeVideoPlayerTableViewCell.h"
#import "ECHomeVideoTableViewCell.h"
#import "ECHomeCityTableViewCell.h"
#import "SHVideoPlayerView.h"

#import "ECWorksModel.h"
#import "ECWorksTableViewCell.h"
#import "ECWorksDetailViewController.h"

#import "ECNewsTypeModel.h"
#import "ECHomeNewsListModel.h"

#import "ECNewsSearchViewController.h"
#import "ECAdvertisingViewController.h"
#import "ECNewsSearchViewController.h"
#import "ECNewsBigImageViewViewController.h"
#import "ECNewsInfoViewController.h"
#import "ECNewsVideoInfoViewController.h"
#import "ECSelectCityViewController.h"

#define News_Type_City_Code                @"INFORMATION_CHENGSHI"
#define News_Type_Video_Code               @"INFORMATION_SHIPIN"


@interface ECHomeViewController ()
/**
 搜索按钮
 */
@property (strong,nonatomic) UIButton *searchBtn;

//类别相关  start
@property (strong,nonatomic) ECHomeOptionsView *optionsView;

@property (strong,nonatomic) NSMutableArray *newsTypeArray;

@property (assign,nonatomic) NSInteger currentTypeIndex;

@property (assign,nonatomic) BOOL isCityNewsType;

//类别相关 END
//视频相关 start
@property (strong,nonatomic) SHVideoPlayerView *videoPlayerView;

@property (strong,nonatomic) NSIndexPath *currentIndexPath;

@property (strong,nonatomic) UIViewController *fullVC;

@property (assign,nonatomic) BOOL isFull;
//视频相关  end
/**
 列表内容数据
 */
@property (strong,nonatomic) NSMutableArray *dataArray;
/*!
 *  页码
 */
@property (assign,nonatomic) NSInteger pageIndex;

//----滑动手势----//
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, assign) CGFloat beganX;

@property (nonatomic, assign) CGFloat beganY;
//----滑动手势----//

@end

@implementation ECHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全屋构";
    [self createData];
    [self createUI];
}

- (void)createData{
    _isFull = NO;
    _isCityNewsType = NO;
    _newsTypeArray = [NSMutableArray new];
    _dataArray = [NSMutableArray array];
}

- (void)createUI{
    WEAK_SELF
    
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_searchBtn setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [_searchBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        ECNewsSearchViewController *searchVC = [[ECNewsSearchViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:searchVC animated:YES titleLabel:@"资讯搜索"];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBtn];
    
    if (!_optionsView) {
        _optionsView = [ECHomeOptionsView new];
    }
    [_optionsView setDidSelectIndex:^(NSInteger index) {
        weakSelf.currentTypeIndex = index;
        ECNewsTypeModel *typeModel = weakSelf.optionsView.newsTypeArray[0][weakSelf.currentTypeIndex];
        weakSelf.isCityNewsType = [typeModel.BIANMA isEqualToString:News_Type_City_Code];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    [_optionsView setCloseClick:^(NSMutableArray *array) {
        weakSelf.optionsView.newsTypeArray = array;
        ECNewsTypeModel *typeModel = weakSelf.optionsView.newsTypeArray[0][weakSelf.currentTypeIndex];
        weakSelf.isCityNewsType = [typeModel.BIANMA isEqualToString:News_Type_City_Code];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        if (weakSelf.newsTypeArray.count == 0) {
            [weakSelf requestUserNewsType:^{
                [weakSelf requestNewsData];
            }];
        }else{
            [weakSelf requestNewsData];
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex ++;
        [weakSelf requestNewsData];
    }];
    
    [self.view addSubview:_optionsView];
    
    [_optionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.optionsView.mas_bottom);
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:_pan];
    _pan.enabled = NO;
}

- (void)panGesture:(id)sender {
    UIPanGestureRecognizer *panGestureRecognizer;
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        panGestureRecognizer = (UIPanGestureRecognizer *)sender;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan){
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        _beganX = translation.x;
        _beganY = translation.y;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        if (fabs(translation.y - _beganY) < fabs(translation.x - _beganX)) {
            if (translation.x > _beganX && (translation.x - _beganX) > OFFSET_TRIGGER_DIRECTION) {
                //goBack
                if (_currentTypeIndex > 0) {
                    [self changeNum:-1];
                }
            }else if (translation.x < _beganX && (_beganX - translation.x) > OFFSET_TRIGGER_DIRECTION){
                //goForward
                if (_currentTypeIndex < ((NSArray *)self.optionsView.newsTypeArray[0]).count - 1) {
                    [self changeNum:1];
                }
            }
        }
        _beganX = 0;
        _beganY = 0;
    }
}

-(void)changeNum:(NSInteger)num {
    self.currentTypeIndex = self.currentTypeIndex + num;
    ECNewsTypeModel *typeModel = self.optionsView.newsTypeArray[0][self.currentTypeIndex];
    self.isCityNewsType = [typeModel.BIANMA isEqualToString:News_Type_City_Code];
    self.optionsView.currentIndex = self.currentTypeIndex;
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark  请求方法
- (void)requestUserNewsType:(void(^)())success{
    WEAK_SELF
    [ECHTTPServer requestUserNewsTypeSucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *dict in result[@"inInforType"]) {
                ECNewsTypeModel *model = [ECNewsTypeModel yy_modelWithDictionary:dict];
                [array addObject:model];
            }
            [weakSelf.newsTypeArray addObject:array.mutableCopy];
            [array removeAllObjects];
            for (NSDictionary *dict in result[@"outinforType"]) {
                ECNewsTypeModel *model = [ECNewsTypeModel yy_modelWithDictionary:dict];
                [array addObject:model];
            }
            [weakSelf.newsTypeArray addObject:array.mutableCopy];
            //判断用户是否登录，如果登录则使用请求结果作为类型，否则判断本地是否有归档，如果有使用归档，否则使用请求结果作为类型
            if (EC_USER_WHETHERLOGIN && [ECNewsTypeModel loadNewsType] != nil) {
                weakSelf.optionsView.newsTypeArray = [ECNewsTypeModel loadNewsType];
            }else{
                weakSelf.optionsView.newsTypeArray = weakSelf.newsTypeArray;
            }
            weakSelf.optionsView.currentIndex = 0;
            success();
        }else{
            RequestError
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)requestNewsData{
    WEAK_SELF
    
    //关闭播放
    [self.videoPlayerView stopPlayer];
    [self.videoPlayerView removeFromSuperview];
    
    ECNewsTypeModel *model = self.optionsView.newsTypeArray[0][self.currentTypeIndex];
    NSString *type = model.BIANMA;
    if (self.isCityNewsType) {
        NSString *cityStr = [CMLocationManager sharedCMLocationManager].userNewsCityName;
        if (cityStr.length == 0) {//如果未得到城市，则触发定位
            cityStr = [CMLocationManager sharedCMLocationManager].currentLocationCityName;
            if (cityStr.length == 0) {
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                return;
            }
        }
        type = [NSString stringWithFormat:@"%@%@",News_Type_City_Code,cityStr];
    }
    
    [ECHTTPServer requestNewsDataWithType:type WithPageIndex:self.pageIndex Succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            //判断请求的是否是分享的内容
            ECNewsTypeModel *model = weakSelf.optionsView.newsTypeArray[0][weakSelf.currentTypeIndex];
            if ([model.BIANMA isEqualToString:@"INFORMATION_FENXIANG"]) {
                for (NSDictionary *dict in result[@"caseList"]) {
                    [weakSelf.dataArray addObject:[ECWorksModel yy_modelWithDictionary:dict]];
                }
            }else{
                for (NSDictionary *dict in result[@"inforList"]) {
                    [weakSelf.dataArray addObject:[ECHomeNewsListModel yy_modelWithDictionary:dict]];
                }
            }
            
            [weakSelf.tableView reloadData];
            weakSelf.pan.enabled = YES;
            if ([result[@"page"][@"totalPage"] integerValue] == weakSelf.pageIndex) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        RequestFailure
    }];
}

- (void)createVideoPlayerView{
    WEAK_SELF
    
    [self.videoPlayerView stopPlayer];
    [self.videoPlayerView removeFromSuperview];
    
    ECHomeNewsListModel *model = self.dataArray[self.currentIndexPath.row];
    
    SHVideoPlayerView *videoPlayerView = [[SHVideoPlayerView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREENWIDTH, SCREENWIDTH * 422.f / 750.f)];
    videoPlayerView.videoUrl = IMAGEURL(model.cover2);
    
    ECHomeVideoPlayerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    [cell.contentView addSubview:videoPlayerView];
    
    self.videoPlayerView = videoPlayerView;
    
    if (!_fullVC) {
        _fullVC = [UIViewController new];
    }
    
    [videoPlayerView setFullScreenClick:^(BOOL isFull) {
        weakSelf.isFull = isFull;
        if (isFull) {
            [weakSelf presentViewController:weakSelf.fullVC animated:NO completion:^{
                weakSelf.videoPlayerView.frame = weakSelf.fullVC.view.bounds;
                [weakSelf.fullVC.view addSubview:weakSelf.videoPlayerView];
            }];
        }else{
            ECHomeVideoPlayerTableViewCell *currentCell = [weakSelf.tableView cellForRowAtIndexPath:weakSelf.currentIndexPath];
            [weakSelf.fullVC dismissViewControllerAnimated:NO completion:^{
                weakSelf.videoPlayerView.frame = CGRectMake(0.f, 0.f, SCREENWIDTH, SCREENWIDTH * 422.f / 750.f);
                [currentCell addSubview:weakSelf.videoPlayerView];
            }];
        }
    }];
    //增加一下播放次数
    [ECHTTPServer requestAddVideoPlayCountWithInfomationId:model.newsID
                                                   succeed:^(NSURLSessionDataTask *task, id result) {
                                                       
                                                   }
                                                    failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                       
                                                    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isCityNewsType ? self.dataArray.count + 1 : self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    
    if (self.isCityNewsType && indexPath.row == 0) {
        ECHomeCityTableViewCell *cell = [ECHomeCityTableViewCell cellWithTableView:tableView];
        cell.city = [CMLocationManager sharedCMLocationManager].userNewsCityName;
        return cell;
    }
    
    //判断请求的是否是分享的内容
    ECNewsTypeModel *newsTypeModel = self.optionsView.newsTypeArray[0][self.currentTypeIndex];
    if ([newsTypeModel.BIANMA isEqualToString:@"INFORMATION_FENXIANG"]) {
        ECWorksTableViewCell *cell = [ECWorksTableViewCell cellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else{
        ECHomeNewsListModel *model = self.dataArray[self.isCityNewsType ? (indexPath.row -1) : indexPath.row];
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
            case 5:{//直接播放视频
                ECHomeVideoPlayerTableViewCell *cell = [ECHomeVideoPlayerTableViewCell cellWithTableView:tableView];
                cell.model = model;
                cell.indexPath = indexPath;
                [cell setStartVideoPlayer:^(NSIndexPath *indexpath) {
                    weakSelf.currentIndexPath = indexPath;
                    [weakSelf createVideoPlayerView];
                }];
                [cell setShareClickBlock:^{
                    [CMPublicMethod shareToPlatformWithTitle:model.title WithLink:[NSString stringWithFormat:@"%@BIANMA=%@&informationId=%@",[CMPublicDataManager sharedCMPublicDataManager].publicDataModel.informationShareUrl,model.classify,model.newsID] WithQCode:NO];
                }];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCityNewsType && indexPath.row == 0) {
        return 30.f;
    }
    ECNewsTypeModel *newsTypeModel = self.optionsView.newsTypeArray[0][self.currentTypeIndex];
    
    if ([newsTypeModel.BIANMA isEqualToString:@"INFORMATION_FENXIANG"]) {
        return 101.f + SCREENWIDTH * (350.f / 750.f);
    }else{
        ECHomeNewsListModel *model = self.dataArray[self.isCityNewsType ? (indexPath.row -1) : indexPath.row];
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    if (self.isCityNewsType && indexPath.row == 0) {
        //添加监听通知
        ECSelectCityViewController *selectCityVC = [[ECSelectCityViewController alloc] init];
        selectCityVC.type = 0;
        [SELF_BASENAVI pushViewController:selectCityVC animated:YES titleLabel:@"选择城市"];
        [selectCityVC setSelectCityBlock:^(ECCityModel *model, ECCityModel *detailModel) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
        return;
    }
    
    ECNewsTypeModel *newsTypeModel = self.optionsView.newsTypeArray[0][self.currentTypeIndex];
    
    if ([newsTypeModel.BIANMA isEqualToString:@"INFORMATION_FENXIANG"]) {
        ECWorksModel *model = self.dataArray[indexPath.row];
        ECWorksDetailViewController *worksDetailVC = [[ECWorksDetailViewController alloc] init];
        worksDetailVC.worksID = model.worksID;
        [SELF_BASENAVI pushViewController:worksDetailVC animated:YES titleLabel:@"详情"];
        return;
    }else{
        ECHomeNewsListModel *model = self.dataArray[self.isCityNewsType ? (indexPath.row -1) : indexPath.row];
        model.isView = @"1";
        [self.tableView reloadData];
        __block ECHomeNewsListModel *weakModel = model;
        switch (model.inforType.integerValue) {
            case 0://单图
            case 1://多图
            case 2:{//无图
                ECNewsInfoViewController *newsInfoVC = [[ECNewsInfoViewController alloc] init];
                newsInfoVC.BIANMA = model.classify;
                newsInfoVC.informationId = model.newsID;
                [SELF_BASENAVI pushViewController:newsInfoVC animated:YES titleLabel:@""];
                
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
                [SELF_BASENAVI pushViewController:newsBigImageVC animated:YES titleLabel:@""];
                
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
                [SELF_BASENAVI pushViewController:advertisingVC animated:YES titleLabel:@""];
            }
                break;
            case 5://直接播放视频
            case 6:{//不可直接播放视频
                ECNewsVideoInfoViewController *videoInfoVC = [[ECNewsVideoInfoViewController alloc] init];
                videoInfoVC.BIANMA = model.classify;
                videoInfoVC.informationId = model.newsID;
                [SELF_BASENAVI pushViewController:videoInfoVC animated:YES titleLabel:@""];
                
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.videoPlayerView.superview && !_isFull) {//点全屏和退出的时候，也会调用scrollViewDidScroll这个方法
        if (![self.tableView.indexPathsForVisibleRows containsObject:self.currentIndexPath]) {//播放video的cell已离开屏幕
            [self.videoPlayerView stopPlayer];
            [self.videoPlayerView removeFromSuperview];
        }
    }
}

@end
