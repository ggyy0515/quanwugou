//
//  ECProductDetailBrandStoryView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductDetailBrandStoryView.h"
#import "ECBrandStoryInfoCell.h"
#import "ECBrandStoryInfoModel.h"
#import "ECBrandStoryWebCell.h"
#import "ECBrandStoryInfoHeader.h"


#import "ECHomeSingleImageTableViewCell.h"
#import "ECHomeMoreImageTableViewCell.h"
#import "ECHomeNoneImageTableViewCell.h"
#import "ECHomeBigImageTableViewCell.h"
#import "ECHomeAdvertisingTableViewCell.h"
#import "ECHomeVideoPlayerTableViewCell.h"
#import "ECHomeVideoTableViewCell.h"
#import "ECHomeCityTableViewCell.h"
#import "SHVideoPlayerView.h"
#import "ECNewsTypeModel.h"
#import "ECHomeNewsListModel.h"
#import "ECNewsSearchViewController.h"
#import "ECAdvertisingViewController.h"
#import "ECNewsSearchViewController.h"
#import "ECNewsBigImageViewViewController.h"
#import "ECNewsInfoViewController.h"
#import "ECNewsVideoInfoViewController.h"
#import "ECSelectCityViewController.h"

@interface ECProductDetailBrandStoryView ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, copy) NSString *protable;
@property (nonatomic, copy) NSString *proId;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ECBrandStoryInfoModel *infoModel;
@property (nonatomic, assign) CGFloat webHeight;
@property (nonatomic, strong) NSMutableArray *dataSource;


//视频相关 start
@property (strong,nonatomic) SHVideoPlayerView *videoPlayerView;

@property (strong,nonatomic) NSIndexPath *currentIndexPath;

@property (strong,nonatomic) UIViewController *fullVC;

@property (assign,nonatomic) BOOL isFull;
//视频相关  end

@end


@implementation ECProductDetailBrandStoryView

#pragma mark - Life cycle

- (instancetype)initWithProtable:(NSString *)protable proId:(NSString *)proId {
    if (self = [super init]) {
        _protable = protable;
        _proId = proId;
        _webHeight = 0;
        _dataSource = [NSMutableArray array];
        [self createUI];
        [self loadDataSource];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_tableView) {
        _tableView = [UITableView new];
    }
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BaseColor;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_tableView registerClass:[ECBrandStoryInfoCell class]
       forCellReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECBrandStoryInfoCell)];
    [_tableView registerClass:[ECBrandStoryWebCell class]
       forCellReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECBrandStoryWebCell)];
    
}

#pragma mark - Actions

- (void)loadDataSource {
    [ECHTTPServer requestBrandStoryWithProId:_proId
                                    protable:_protable
                                     succeed:^(NSURLSessionDataTask *task, id result) {
                                         if (IS_REQUEST_SUCCEED(result)) {
                                             _infoModel = [ECBrandStoryInfoModel yy_modelWithDictionary:result[@"proStory"][@"story"]];
                                             
                                             [_dataSource removeAllObjects];
                                             [result[@"proStory"][@"info"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                 ECHomeNewsListModel *model = [ECHomeNewsListModel yy_modelWithDictionary:dic];
                                                 [_dataSource addObject:model];
                                             }];
                                             
                                             [_tableView reloadData];
                                         } else {
                                             EC_SHOW_REQUEST_ERROR_INFO
                                         }
                                     }
                                      failed:^(NSURLSessionDataTask *task, NSError *error) {
                                         RequestFailure
                                      }];
}

- (void)createVideoPlayerView{
    WEAK_SELF
    
    [self.videoPlayerView stopPlayer];
    [self.videoPlayerView removeFromSuperview];
    
    ECHomeNewsListModel *model = _dataSource[self.currentIndexPath.row];
    
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
            [WEAKSELF_VC_BASENAVI presentViewController:weakSelf.fullVC animated:NO completion:^{
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
}

#pragma mark - UITableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 1;
            
        default:
            return _dataSource.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 8.f)];
    footer.backgroundColor = BaseColor;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 44.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        ECBrandStoryInfoHeader *header = [[ECBrandStoryInfoHeader alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44.f)];
        if (_dataSource.count > 0) {
            header.title = @"品牌资讯";
            header.backgroundColor = [UIColor whiteColor];
        } else {
            header.title = @"暂无品牌资讯";
            header.backgroundColor = BaseColor;
        }
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 104.f;
        case 1:
            return _webHeight == 0 ? 200.f : _webHeight;
        default:
        {
            ECHomeNewsListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
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
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    switch (indexPath.section) {
        case 0:
        {
            ECBrandStoryInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECBrandStoryInfoCell)
                                                                         forIndexPath:indexPath];
            cell.model = _infoModel;
            return cell;
        }
        case 1:
        {
            ECBrandStoryWebCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECBrandStoryWebCell)
                                                                        forIndexPath:indexPath];
            [cell setDidLoadWenHeight:^(CGFloat webHeight) {
                weakSelf.webHeight = webHeight;
                [weakSelf.tableView reloadData];
            }];
            [cell setClickCheckMore:^{
                [weakSelf.tableView reloadData];
            }];
            cell.content = _infoModel.content ? _infoModel.content : @"";
            return cell;
        }
            
        default:
        {
            ECHomeNewsListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
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
                        [SVProgressHUD showInfoWithStatus:@"分享视频"];
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
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    if (indexPath.section == 2) {
        ECHomeNewsListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
        model.isView = @"1";
        [self.tableView reloadData];
        __weak ECHomeNewsListModel *weakModel = model;
        switch (model.inforType.integerValue) {
            case 0://单图
            case 1://多图
            case 2:{//无图
                ECNewsInfoViewController *newsInfoVC = [[ECNewsInfoViewController alloc] init];
                newsInfoVC.BIANMA = model.classify;
                newsInfoVC.informationId = model.newsID;
                [SELF_VC_BASEVAV pushViewController:newsInfoVC animated:YES titleLabel:model.resource];
                
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
                [SELF_VC_BASEVAV pushViewController:newsBigImageVC animated:YES titleLabel:model.title];
                
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
                [SELF_VC_BASEVAV pushViewController:advertisingVC animated:YES titleLabel:model.title];
            }
                break;
            case 5://直接播放视频
            case 6:{//不可直接播放视频
                ECNewsVideoInfoViewController *videoInfoVC = [[ECNewsVideoInfoViewController alloc] init];
                videoInfoVC.BIANMA = model.classify;
                videoInfoVC.informationId = model.newsID;
                [SELF_VC_BASEVAV pushViewController:videoInfoVC animated:YES titleLabel:model.resource];
                
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
